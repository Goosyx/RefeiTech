class CartController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_product, only: [:update_quantity]


  def add_to_cart
    product_id = params[:id].to_i
    quantity = params[:quantity].to_i
  
    if quantity <= 0
      render json: { status: 'fail', message: 'Quantidade inválida' }, status: :bad_request
      return
    end
  
    product = Product.find_by(id: product_id)
    unless product
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
      return
    end

    if quantity > product.quantity
      render json: { status: 'fail', message: 'Quantidade solicitada excede o estoque disponível' }, status: :bad_request
      return
    end

    cart = session[:cart] || []
    product_exist = cart.find { |item| item['id'] == product_id }
  
    if product_exist
      new_quantity = product_exist['quantity'] + quantity
      if new_quantity > product.quantity
        render json: { status: 'fail', message: 'Quantidade total no carrinho excede o estoque disponível' }, status: :bad_request
        return
      end
      product_exist['quantity'] = new_quantity
    else
      cart << { 'id' => product.id, 'quantity' => quantity }
    end
  
    session[:cart] = cart
    Rails.logger.debug "Carrinho atualizado: #{session[:cart].inspect}"
    render json: { status: 'success', message: 'Produto adicionado ao carrinho', cart: cart }, status: :ok
  end
  
  def show
    cart = session[:cart] || []
    total_price = 0
    cart_with_details = []
  
    cart.each do |item|
      product = Product.find_by(id: item['id'])
      if product
        item_total_price = product.price.to_f * item['quantity']
        total_price += item_total_price
        
        cart_with_details << {
          'id' => product.id,
          'name' => product.name,
          'quantity' => item['quantity'],
          'unit_price' => product.price.to_f,
          'item_price' => item_total_price
        }
      end
    end
    session[:total_price] = total_price
    render json: { status: 'success', cart: cart_with_details, total_price: total_price }, status: :ok
  end
  
  
  def fetch_cart_items
    cart = session[:cart] || []
    cart.map do |item|
      product = Product.find_by(id: item['id'])
      if product
        {
          name: product.name,
          price: product.price,
          quantity: item['quantity']
        }
      end
    end.compact
  end  

  def update_quantity
    Rails.logger.info "Parameters: #{params.inspect}" # Adiciona log para depuração
    quantity = params[:quantity].to_i
    cart = session[:cart] || []
    product_in_cart = cart.find { |item| item['id'] == @product.id }
  
    if product_in_cart
      product_in_cart['quantity'] = quantity
      session[:cart] = cart
      render json: { status: 'success', message: 'Quantidade atualizada no carrinho', cart: cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado no carrinho' }, status: :not_found
    end
  end
  
  def remove_product
    product_id = params[:product_id].to_i
    cart = session[:cart] || []
  
    product_in_cart = cart.find { |item| item['id'] == product_id }
  
    if product_in_cart
      cart.delete(product_in_cart)
      session[:cart] = cart
      render json: { status: 'success', message: 'Produto removido do carrinho', cart: cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado no carrinho' }, status: :not_found
    end
  end
  

  def clear_cart
    session[:cart] = [] # Limpa o carrinho
    render json: { status: 'success', message: 'Carrinho esvaziado com sucesso' }, status: :ok
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id]) # Alterado para usar :id
    unless @product
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end
end
