class AddCartToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :cart, null: true, foreign_key: true, index: true
  end
end
