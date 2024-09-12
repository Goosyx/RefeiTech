class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.string :ra, null: false
      t.string :password_digest, null: false
    end

    # Cria um admin após a tabela ser criada
    Admin.create!(ra: 'admin', password: '123456') if table_exists?(:admins)
  end
end
