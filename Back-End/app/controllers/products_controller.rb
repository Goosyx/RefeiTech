class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token 
  before_action :set_product, only: [:check_stock, :destroy, :update]

  def create
    @product_new = Product.new(Product.permitted_params(params))
  
    if @product_new.save
      render json: { status: 'success', message: 'Produto adicionado com sucesso', product: @product_new }, status: :created
    else
      render json: { status: 'fail', message: 'Erro ao adicionar produto', errors: @product_new.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @products = Product.all
    @user_id = current_user.id if current_user
    render json: { status: 'success', product: @products }, status: :ok
  end

  def check_stock
    if @product
      render json: { status: 'success', product: @product, stock: @product.quantity }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end

  def update
    if @product.update(Product.permitted_params(params))
      render json: { status: 'success', message: 'Produto atualizado com sucesso', product: @product }, status: :ok
    else
      render json: { status: 'fail', message: 'Erro ao atualizar produto', errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    # Verifica se o produto existe
    if @product
      # Verifica se o produto está presente na tabela 'payments'
      payment = Payment.find_by(products_id: @product.id)
  
      if payment
        # Se o produto estiver vinculado a algum pagamento, bloqueia a remoção
        render json: { status: 'fail', message: 'Produto não pode ser removido, pois está vinculado a um pagamento' }, status: :unprocessable_entity
      elsif @product.destroy
        # Se não estiver vinculado e a remoção for bem-sucedida
        render json: { status: 'success', message: 'Produto removido com sucesso' }, status: :ok
      else
        # Caso ocorra um erro ao remover o produto
        render json: { status: 'fail', message: 'Erro ao remover o produto' }, status: :unprocessable_entity
      end
    else
      # Se o produto não for encontrado
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end  
  private

  def set_product
    @product = Product.find_by(id: params[:id])
    unless @product
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end
end
