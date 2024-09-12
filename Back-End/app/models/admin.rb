class Admin < ApplicationRecord
  
  has_secure_password

  validates :ra, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
  
end