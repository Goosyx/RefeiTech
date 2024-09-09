class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    case params[:payment_method]
    when 'pix'
      result = Payment.create_pix_payment(Payment.total_cart_value(session[:cart] || []))
      if result[:status] == 'success'
        render json: result, status: :ok
      else
        render json: result, status: :bad_request
      end
    when 'wallet'
      create_wallet_payment
    when 'credit_card'
      create_credit_card_payment
    else
      render json: { status: 'fail', message: 'Método de pagamento inválido' }, status: :bad_request
    end
  end

  def create_wallet_payment
    user = User.find_by(ra: params[:ra])
    if user && user.balance >= (Payment.total_cart_value(session[:cart] || []))
      user.update(balance: user.balance - (Payment.total_cart_value(session[:cart] || [])))
      create_purchase
      process_payment
      render json: { status: 'success', message: 'Pagamento realizado com sucesso com Carteira' }, status: :ok
    else
      render json: { status: 'fail', message: 'Saldo insuficiente na carteira ou usuário não encontrado' }, status: :unprocessable_entity
    end
  end

  def validate
    case params[:payment_method]
    when 'pix'
      validate_pix_payment
    when 'credit_card'
      card_number = params[:card_number]
      card_expiry = params[:expiry_date]
      card_cvv = params[:cvv]
  
      if Payment.valid_credit_card_number?(card_number) && Payment.valid_expiry_date?(card_expiry)
        render json: { status: 'success', message: 'Cartão de crédito válido' }, status: :ok
      else
        render json: { status: 'fail', message: 'Número do cartão de crédito ou data de validade inválidos' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'fail', message: 'Método de pagamento inválido' }, status: :bad_request
    end
  end

  def add_balance
    balance = params[:balance].to_f
    user = User.find_by(ra: params[:ra])
    
    if balance <= 0
      render json: { status: 'fail', message: 'Valor inválido' }, status: :bad_request
      return
    end

    if user
      user.update(balance: user.balance + balance)
      render json: { status: 'success', message: "Saldo adicionado com sucesso! Saldo atual: #{user.balance}" }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não encontrado' }, status: :not_found
    end
  end

  # Obtenção do saldo da carteira
  def get_balance
    user = User.find_by(ra: params[:ra])
    if user
      render json: { status: 'success', balance: user.balance }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não encontrado' }, status: :not_found
    end
  end

  private

  def validate_pix_payment
    charge_id = params[:charge_id]
    url = URI("https://api.openpix.com.br/api/v1/charge/#{charge_id}")

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = 'Q2xpZW50X0lkXzU2NGEwZDgzLTg0MDMtNDMxNS05MzMyLWUzNWJjNjY3YjFhZjpDbGllbnRfU2VjcmV0X25qN1pDcHQzWVIrVUNhV1RONFNsV3hXSnpNajlZeExoekxnWC9CVDVGUG89' # Substitua com seu app_id

    response = Payment.send_request(url, request)

    if response.is_a?(Net::HTTPSuccess)
      handle_pix_response(JSON.parse(response.body))
    else
      render json: { status: 'fail', message: "Erro ao consultar status do pagamento: #{response.body}" }, status: :bad_request
    end
  end

  def handle_pix_response(response_body)
    charge_status = response_body.dig('charge', 'status')

    case charge_status
    when 'COMPLETED'
      create_purchase
      process_payment
      render json: { status: 'success', message: 'Pix pago com sucesso' }, status: :ok
    when 'ACTIVE'
      render json: { status: 'fail', message: 'Pix não efetuado' }, status: :ok
    else
      render json: { status: 'fail', message: "Status de pagamento desconhecido: #{charge_status}" }, status: :unprocessable_entity
    end
  end

  def create_credit_card_payment
    card_number = params[:card_number]
    card_expiry = params[:card_expiry]
    card_cvv = params[:card_cvv]

    if Payment.valid_credit_card_number?(card_number) && Payment.valid_expiry_date?(card_expiry)
      response = { success: true }
      if response[:success] 
        create_purchase
        process_payment
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Cartão de Crédito' }, status: :ok
      else
        render json: { status: 'fail', message: 'Falha ao processar pagamento' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'fail', message: 'Número do cartão de crédito ou data de validade inválidos' }, status: :unprocessable_entity
    end
  end
  
  def create_purchase
    cart = session[:cart] || []
    cart.each do |item|
      Payment.create(
        users_ra: current_user.ra,
        products_id: item["id"],
        quantity: item["quantity"], 
        date_payment: Time.now
      )
    end
  end
  def process_payment
    cart = session[:cart] || []
    cart.each do |item|
      product = Product.find_by(id: item["id"])
      if product && product.quantity >= item["quantity"]
        product.update(quantity: product.quantity - item["quantity"])
        session[:cart] = []
      else
        render json: { status: 'fail', message: "Quantidade insuficiente para o produto #{product&.name}" }, status: :unprocessable_entity
        return
      end
    end
  end
end