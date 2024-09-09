class PurchasesController < ApplicationController
  skip_before_action :verify_authenticity_token

  require 'rqrcode'

  def index
    # Verifica se o usuário está logado
    if session[:user_id].present?
      user = User.find(session[:user_id])
      
      # Busca todos os pagamentos relacionados ao usuário logado
      payments = Payment.where(users_ra: user.ra)
      
      render json: { status: 'success', payments: payments }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não logado' }, status: :unauthorized
    end
  end

  # Exibe os pagamentos disponíveis (com purchases > 0) para o usuário atual
  def show
    user = User.find_by(ra: params[:user][:ra]) # Busca o RA dos parâmetros
    if user
      payments = Payment.where(users_ra: user.ra).where("purchases  > 0")
      render json: { status: 'success', payments: payments }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não encontrado' }, status: :not_found
    end
  end
  # Adiciona os pagamentos selecionados ao carrinho final na sessão
  def add_to_final_cart
    payment_ids = params.require(:payment_ids)
    user_ra = params[:ra] || session[:ra]
    cart = session[:cart] || []

    # Verifica se user_ra está presente
    if user_ra.blank?
      render json: { status: 'fail', message: 'RA do usuário não fornecido' }, status: :unprocessable_entity
      return
    end
    
    # Verifica se payment_ids é um array
    unless payment_ids.is_a?(Array)
      render json: { status: 'fail', message: 'IDs de pagamento inválidos' }, status: :unprocessable_entity
      return
    end
    
    # Busca pagamentos
    payments = Payment.where(id: payment_ids, users_ra: user_ra).where("purchases>0")

    # Verifica se algum pagamento foi encontrado
    if payments.present?
      payments.each do |payment|
        cart << { id: payment.id, products_id: payment.products_id, date_payment: payment.date_payment }
      end
      session[:cart] = cart
      render json: { status: 'success', cart: cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Nenhum item válido selecionado' }, status: :unprocessable_entity
    end
  end
  # Gera o QR Code a partir do carrinho armazenado na sessão
  def generate_qrcode
    cart = session[:cart]

    if cart.present?
      data = cart.to_json
      qrcode = RQRCode::QRCode.new(data)
      svg = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6)

      # Geração de imagem PNG (pode precisar de configuração extra no Rails para servir arquivos estáticos)
      qrcode_png = qrcode.as_png(size: 350)
      File.open(Rails.root.join('public', 'qrcode.png'), 'wb') { |f| f.write qrcode_png.to_s }

      render json: {
        qrcode_svg: svg,
        qrcode_image_url: "/qrcode.png", # Exponha essa URL corretamente no servidor (exemplo: via config.assets)
        cart: cart
      }, status: :ok
    else
      render json: { status: 'fail', message: 'Carrinho vazio' }, status: :unprocessable_entity
    end
  end

  # Valida o QR Code e atualiza os pagamentos no banco
  def validate_qrcode
    scanned_data = params[:qrcode_data]

    if scanned_data.present?
      begin
        cart = JSON.parse(scanned_data)
      rescue JSON::ParserError => e
        Rails.logger.error("Erro ao decodificar QR Code: #{e.message}")
        render json: { status: 'fail', message: 'Erro ao decodificar QR Code' }, status: :unprocessable_entity
        return
      end

      cart.each do |item|
        payment = Payment.find_by(id: item["id"], users_ra: session[:ra])

        if payment && payment.purchases >= item["purchases"]
          # Subtrai a quantidade usada
          new_quantity = payment.purchases - item["purchases"]

          if new_quantity > 0
            payment.update(quantity: new_quantity)
          else
            payment.destroy
          end
        else
          Rails.logger.error("Pagamento não encontrado ou quantidade insuficiente: #{item['id']}")
          render json: { status: 'fail', message: "Pagamento não encontrado ou quantidade insuficiente para o item #{item['id']}" }, status: :unprocessable_entity
          return
        end
      end

      render json: { status: 'success', message: 'QR Code validado e pagamentos atualizados' }, status: :ok
    else
      render json: { status: 'fail', message: 'Dados do QR Code não fornecidos' }, status: :unprocessable_entity
    end
  end
end
