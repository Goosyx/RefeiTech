class PurchasesController < ApplicationController
  require 'rqrcode'
  def show
    user = User.find_by(ra: session[:ra]) # Supondo que o RA esteja salvo na sessão
    if user
      payments = Payment.where(user_ra: user.ra).where("purchases > 0")
      render json: { status: 'success', payments: payments }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não encontrado' }, status: :not_found
    end
  end
  def add_to_final_cart
    payment_ids = params[:payment_ids]
    cart = session[:cart] || []
    
    payments = Payment.where(id: payment_ids, user_ra: session[:ra]).where("purchases > 0")
    
    if payments.present?
      payments.each do |payment|
        cart << { id: payment.id, product_id: payment.product_id, date_payment: payment.date_payment }
      end
      session[:cart] = cart
      render json: { status: 'success', cart: cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Nenhum item válido selecionado' }, status: :unprocessable_entity
    end
  end
  
  def generate_qrcode
    cart = session[:cart]
    
    if cart.present?
      data = cart.to_json
      qrcode = RQRCode::QRCode.new(data)
      svg = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6)
      
      # Gerar uma URL de imagem para QR Code, além de SVG
      qrcode_png = qrcode.as_png(size: 200)
      File.open("qrcode.png", "wb") { |f| f.write qrcode_png.to_s }

      render json: {
        qrcode_svg: svg,
        qrcode_image_url: "/path/to/qrcode.png", # Certifique-se de expor esta URL corretamente no servidor
        cart: cart
      }, status: :ok
    else
      render json: { status: 'fail', message: 'Carrinho vazio' }, status: :unprocessable_entity
    end
  end
  
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
        payment = Payment.find_by(id: item["id"], user_ra: session[:ra])
        
        if payment && !payment.purchases
          #payment.update(purchases: true)
        else
          Rails.logger.error("Pagamento já utilizado ou não encontrado: #{item['id']}")
          render json: { status: 'fail', message: "Pagamento não encontrado ou já utilizado para o item #{item['id']}" }, status: :unprocessable_entity
          return
        end
      end
      
      render json: { status: 'success', message: 'QR Code validado e pagamentos atualizados' }, status: :ok
    else
      render json: { status: 'fail', message: 'Dados do QR Code não fornecidos' }, status: :unprocessable_entity
    end
  end
end