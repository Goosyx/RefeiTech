class PurchasesController < ApplicationController
  skip_before_action :verify_authenticity_token

  require 'rqrcode'

  # Exibe os pagamentos disponíveis (com purchases > 0) para o usuário atual
  def show
    user = User.find(session[:user_id]) # Busca o usuário pela sessão
    
    if user
      # Buscar todos os pagamentos com RA do usuário e onde purchases > 0
      payments = Payment.where(users_ra: user.ra).where("purchases > 0")
      
      # Agrupar pagamentos por produto e somar a quantidade de compras (fichas)
      grouped_payments = payments.group_by { |payment| payment.products_id }
      
      payments_with_products = []
  
      grouped_payments.each do |product_id, payment_group|
        # Encontrar o produto correspondente ao product_id
        product = Product.find_by(id: product_id)
        
        # Somar o total de compras (fichas) para o mesmo produto
        total_purchases = payment_group.sum(&:purchases)
  
        payments_with_products << {
          product: product,
          total_purchases: total_purchases
        }
      end
      
      # Enviar tanto os pagamentos agrupados quanto os produtos para o frontend
      render json: { status: 'success', payments: payments_with_products }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não encontrado' }, status: :not_found
    end
  end
  
  # Adiciona os pagamentos selecionados ao carrinho final na sessão
  def add_to_final_cart
    payment_data = params[:payments].first[:payment]
    product_id = payment_data[:products_id].to_i
    purchases = payment_data[:purchases].to_i
    
    if purchases <= 0
      render json: { status: 'fail', message: 'Quantidade inválida' }, status: :bad_request
      return
    end
    
    # Verifica se o produto existe
    product = Product.find_by(id: product_id)
    
    unless product
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
      return
    end
    
    # Atualiza o carrinho baseado no `product_id`
    final_cart = session[:final_cart_session] || []
    final_cart << { 
      'product_id' => product.id, 
      'product_name' => product.name, 
      'purchases' => purchases, 
      'unit_price' => product.price.to_f
    }
    
    session[:final_cart_session] = final_cart
    render json: { status: 'success', message: 'Produto adicionado ao carrinho', cart: final_cart }, status: :ok
  end

  def clear_cart
    session[:final_cart_session] = [] # Limpa o carrinho ao redefinir a sessão para um array vazio
    render json: { status: 'success', message: 'Carrinho limpo com sucesso' }, status: :ok
  end

  def remove_product
    product_id = params[:product_id].to_i
    final_cart = session[:final_cart_session] || []
  
    # Remove todos os itens do carrinho com o product_id específico
    updated_cart = final_cart.reject { |item| item['product_id'] == product_id }
  
    # Atualiza o carrinho na sessão
    session[:final_cart_session] = updated_cart
  
    if updated_cart.size < final_cart.size
      render json: { status: 'success', message: 'Produto removido do carrinho', cart: updated_cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado no carrinho' }, status: :not_found
    end
  end

  def show_cart
    final_cart = session[:final_cart_session] || []
  
    cart_details = final_cart.map do |item|
      product = Product.find_by(id: item['product_id'])
      
      if product
        {
          product_id: product.id,
          product_name: product.name,
          purchases: item['purchases'],
          unit_price: product.price.to_f
        }
      else
        Rails.logger.error("Produto não encontrado para o ID: #{item['product_id']}")
        nil # Ignora produtos que não foram encontrados
      end
    end.compact
  
    if cart_details.any?
      render json: { status: 'success', cart: cart_details }, status: :ok
    else
      render json: { status: 'fail', message: 'Carrinho vazio ou produtos inválidos' }, status: :unprocessable_entity
    end
  end
  def generate_qrcode
    final_cart = session[:final_cart_session]
    user = User.find_by(id: session[:user_id]) # Busca o usuário pela sessão para garantir o RA
    
    if final_cart.present? && user.present?
      user_ra = user.ra # Pegando o RA do usuário da sessão
      
      # Caminho fixo dentro do diretório 'public', onde Rails tem permissões de escrita
      qrcode_filepath = Rails.root.join('public', 'qrcode.png')
  
      # Apagar o QR code antigo, se ele existir
      File.delete(qrcode_filepath) if File.exist?(qrcode_filepath)     
      
      data = {
        cart: final_cart,
        user_ra: user_ra
      }.to_json
  
      # Gerar o QR code com os dados
      qrcode = RQRCode::QRCode.new(data)
      svg = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6)
      
      # Gerar uma imagem PNG do QR code
      qrcode_png = qrcode.as_png(size: 350)
      File.open(qrcode_filepath, "wb") { |f| f.write(qrcode_png.to_s) }
  
      render json: {
      status: 'success',
      qrcode_svg: svg,
      qrcode_image_url: "/qrcode.png?t=#{Time.now.to_i}",  # Adiciona um timestamp para evitar cache
      cart: final_cart
      }, status: :ok
    else
      render json: { status: 'fail', message: 'Carrinho vazio ou RA do usuário não encontrado' }, status: :unprocessable_entity
    end
  end

  # Valida o QR code e o RA do usuário
  def validate_qrcode
    scanned_data = params[:qrcode_data]
    user = User.find_by(id: session[:user_id]) # Busca o usuário pela sessão para garantir o RA atual

    if scanned_data.present? && user.present?
      user_ra = user.ra # Pegando o RA do usuário da sessão atual

      begin
        decoded_data = JSON.parse(scanned_data)
        final_cart = decoded_data['cart']
        scanned_ra = decoded_data['user_ra'] # O RA do usuário presente no QR code

        # Verifica se o RA escaneado corresponde ao RA da sessão
        if scanned_ra != user_ra
          render json: { status: 'fail', message: 'RA do QR Code não corresponde ao usuário atual' }, status: :unprocessable_entity
          return
        end
      rescue JSON::ParserError => e
        Rails.logger.error("Erro ao decodificar QR Code: #{e.message}")
        render json: { status: 'fail', message: 'Erro ao decodificar QR Code' }, status: :unprocessable_entity
        return
      end

      final_cart.each do |item|
        product = Product.find_by(id: item["product_id"])
        payment = Payment.find_by(products_id: product.id, users_ra: user_ra)

        if payment && payment.purchases >= item["purchases"]
          # Subtrai a quantidade usada
          new_quantity = payment.purchases - item["purchases"]

          if new_quantity > 0
            payment.update(purchases: new_quantity)
          else
            payment.destroy
          end
        else
          Rails.logger.error("Pagamento não encontrado ou quantidade insuficiente: #{item['product_id']}")
          render json: { status: 'fail', message: "Pagamento não encontrado ou quantidade insuficiente para o produto #{item['product_id']}" }, status: :unprocessable_entity
          return
        end
      end

      render json: { status: 'success', message: 'QR Code validado e pagamentos atualizados' }, status: :ok
    else
      render json: { status: 'fail', message: 'Dados do QR Code ou RA do usuário não fornecidos' }, status: :unprocessable_entity
    end
  end
end
