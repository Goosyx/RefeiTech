require 'rails_helper'

RSpec.describe CartController, type: :controller do
  let!(:product) { Product.create!(name: 'Product 1', price: 100, quantity: 10) }
  
  describe 'POST #add_to_cart' do
    it 'adiciona um produto ao carrinho' do
      post :add_to_cart, params: { id: product.id, quantity: 1 }
      expect(session[:cart]).to include({ 'id' => product.id, 'quantity' => 1 })
      expect(response).to have_http_status(:ok)
    end

    it 'não adiciona com quantidade inválida' do
      post :add_to_cart, params: { id: product.id, quantity: -1 }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'DELETE #remove_product' do
    it 'remove o produto do carrinho' do
      session[:cart] = [{ 'id' => product.id, 'quantity' => 1 }]
      delete :remove_product, params: { product_id: product.id }
      expect(session[:cart]).to be_empty
      expect(response).to have_http_status(:ok)
    end
  end
end
