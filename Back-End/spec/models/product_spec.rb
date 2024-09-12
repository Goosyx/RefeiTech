require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validações' do
    it 'é válido com atributos válidos' do
      product = Product.new(name: 'Product 1', price: 100.0, quantity: 10)
      expect(product).to be_valid
    end

    it 'é inválido sem um nome' do
      product = Product.new(name: nil)
      expect(product).to_not be_valid
    end

    it 'é inválido com um preço negativo' do
      product = Product.new(price: -1)
      expect(product).to_not be_valid
    end

    it 'é inválido sem quantidade' do
      product = Product.new(name: 'Product 1', price: 100.0, quantity: nil)
      expect(product).to_not be_valid
    end
  end
end
