class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      
      t.string :ra, null: false
      t.string :password_digest, null: false
      t.decimal :balance, precision: 10, scale: 2, default: "0.0", null: false
      
      t.timestamps
    end

    add_index :users, :ra, unique: true
    User.create!(ra: 'teste', password: '123456', balance: "100") if table_exists?(:users)
  end
end
