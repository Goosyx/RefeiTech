require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:valid_attributes) { { name: 'Product 1', price: 100, quantity: 10 } }
  let(:invalid_attributes) { { name: '', price: -1, quantity: -1 } }
  let!(:product) { Product.create!(valid_attributes) }

  describe 'POST #create' do
    context 'com atributos válidos' do
      it 'cria um novo produto' do
        expect {
          post :create, params: valid_attributes
        }.to change(Product, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'com atributos inválidos' do
      it 'não cria um novo produto' do
        expect {
          post :create, params: invalid_attributes
        }.to change(Product, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'com atributos válidos' do
      it 'atualiza um produto existente' do
        patch :update, params: { id: product.id, name: 'Updated Product', price: 200, quantity: 5 }
        product.reload
        expect(product.name).to eq('Updated Product')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'com atributos inválidos' do
      it 'falha ao atualizar o produto' do
        patch :update, params: { id: product.id, name: '', price: -10, quantity: -5 }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deleta o produto' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
