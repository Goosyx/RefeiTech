class Payment < ApplicationRecord
  # Associações 
  belongs_to :product, foreign_key: 'products_id'
  belongs_to :user, foreign_key: 'users_ra', primary_key: 'ra'
 
  # Validações
  validates :users_ra, presence: true
  validates :products_id, presence: true
  validates :date_payment, presence: true
  validates :quantity, presence: true
  validates :purchases, presence: true

  # Métodos de classe para validações
  def self.valid_credit_card_number?(number)
    return false if number.nil?  # Verifica se o número é nil
    
    number = number.gsub(/\D/, '')  # Remove caracteres não numéricos
    digits = number.chars.map(&:to_i)
    checksum = 0
    reverse_digits = digits.reverse
    
    reverse_digits.each_with_index do |digit, index|
      if index.odd?
        doubled = digit * 2
        checksum += doubled > 9 ? doubled - 9 : doubled
      else
        checksum += digit
      end
    end
    
    checksum % 10 == 0
  end

  def self.valid_expiry_date?(expiry_date)
    return false unless expiry_date.match?(/\A\d{2}\/\d{2}\z/)
  
    month, year = expiry_date.split('/').map(&:to_i)
    
    return false if month < 1 || month > 12
  
    current_year = Time.now.year % 100
    current_month = Time.now.month
    
    year >= current_year && (year > current_year || (year == current_year && month >= current_month))
  end

  # Métodos de instância para lógica de pagamento
  def self.total_cart_value(cart)
    cart.reduce(0) do |total, item|
      product = Product.find_by(id: item['id'])
      total + (product&.price.to_f * item['quantity'].to_f)
    end
  end


  def self.create_pix_payment(total_cart_value)
    correlation_id = SecureRandom.uuid
    value = total_cart_value * 100  # Certifique-se de que total_cart_value está definido

    url = URI("https://api.openpix.com.br/api/v1/charge")
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Q2xpZW50X0lkXzU2NGEwZDgzLTg0MDMtNDMxNS05MzMyLWUzNWJjNjY3YjFhZjpDbGllbnRfU2VjcmV0X25qN1pDcHQzWVIrVUNhV1RONFNsV3hXSnpNajlZeExoekxnWC9CVDVGUG89' # Substitua com seu app_id

    request.body = {
      correlationID: correlation_id,
      value: value,
      expiresIn: 900
    }.to_json

    response = send_request(url, request)

    if response.is_a?(Net::HTTPSuccess)
      { status: 'success', qr_code: JSON.parse(response.body) }
    else
      { status: 'fail', message: "Falha ao criar cobrança: #{response.body}" }
    end
  end

  def self.send_request(url, request)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = url.scheme == 'https'
    http.request(request)
  end
end
