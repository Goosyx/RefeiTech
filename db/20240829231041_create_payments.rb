class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|

      t.string :users_ra, null: false   
      t.references :products, foreign_key: true
      t.datetime :date_payment  

      t.timestamps
    end
    add_foreign_key :payments, :users, column: :users_ra, primary_key: :ra
  end
end
