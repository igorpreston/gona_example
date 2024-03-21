class AddTableToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :table, index: true, null: true
  end
end
