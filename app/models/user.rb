class User < ApplicationRecord
  
  has_secure_password

  # Associação
  has_many :payments, foreign_key: 'users_ra'

  # Validações
  validates :ra, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :balance, presence: true,
                    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999999999.99 }

  def profile_picture
    # Retorne um URL ou caminho padrão ou uma lógica para obter a imagem do perfil
    "/images/default_profile_picture.png" # Exemplo de uma imagem padrão
  end

  def self.current_user(session)
    if session[:user_type] == 'admin'
      Admin.find_by(id: session[:user_id])
    else
      User.find_by(id: session[:user_id])
    end
  end

  # Método para acessar os parâmetros da requisição
  def self.user_params(params)
    params.require(:user).permit(:ra, :password)
  end
end
