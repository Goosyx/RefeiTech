class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token 


  # Ação para adicionar um novo usuário
  def add_user
    new_user = User.new(user_params)
    if new_user.save
      render json: {status: 'success', message: 'Usuário adicionado com sucesso', user: new_user}, status: :created
    else
      render json: {status: 'fail', message: 'Erro ao adicionar usuário', errors: new_user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # Ação para remover um usuário
  def remove_user
  @user = User.find_by(ra: params[:id])

    if @user && @user.destroy
    render json: { message: 'Usuário removido com sucesso' }, status: :ok
    else
    render json: { errors: 'Usuário não encontrado ou erro ao remover' }, status: :unprocessable_entity
    end
  end

  # Ação para listar todos os usuários
  def list_users
    users = User.all
    render json: {status: 'success', users: users}, status: :ok
  end
  
  def user_params
    params.permit(:ra, :password, :balance)
  end
end