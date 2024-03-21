class CreateOrderUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :order_users do |t|
      t.references :order, null: false, foreign_key: true, index: true
      t.references :user, null: true, foreign_key: true, index: true
      t.string :name
      t.string :email
      t.string :phone
      t.integer :paying_for

      t.timestamps
    end
  end
end
