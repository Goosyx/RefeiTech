class Product < ApplicationRecord
  # Associação
  has_many :payments, foreign_key: 'products_id'

  # Validações
  validates :name, presence: true, length: {maximum: 100}
  validates :price, presence: true, 
                    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999999999.99 }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  # Método para buscar um produto pelo ID
  def self.find_product_by_id(id)
    find_by(id: id)
  end
  def self.find_product_by_name(name)
    find_by(name: name)
  end

  # Método para permitir apenas parâmetros específicos
  def self.permitted_params(params)
    params.permit(:id, :name, :price, :quantity)
  end
end