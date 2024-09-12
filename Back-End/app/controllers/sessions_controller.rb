class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    render 'login'
  end

  def create
    user_params = User.user_params(params)

    user = User.find_by(ra: user_params[:ra])
    admin = Admin.find_by(ra: user_params[:ra])

    if admin && admin.authenticate(user_params[:password])
      session[:user_id] = admin.id
      session[:user_type] = 'admin'
      render json: { status: 'success', message: "Bem-vindo, administrador!", user_type: 'admin' }, status: :ok
    elsif user && user.authenticate(user_params[:password])
      session[:user_id] = user.id
      session[:user_type] = 'user'
      render json: { status: 'success', message: "Bem-vindo, usuário!", user_type: 'user' }, status: :ok
    elsif user.nil? && admin.nil?
      render json: { message: "Usuário não encontrado" }, status: :unprocessable_entity
    else
      render json: { message: "Senha incorreta" }, status: :unprocessable_entity
    end
  end
  
  def debug_session
    render json: { session: session.to_hash }
  end

  private

  def authorize_admin!
    unless User.current_user(session).is_a?(Admin)
      render json: {status: 'fail', message: 'Acesso negado. Apenas administradores podem realizar esta ação.'}, status: :forbidden
    end
  end
end
