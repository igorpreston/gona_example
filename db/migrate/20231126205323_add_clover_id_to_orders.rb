class AddCloverIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :clover_id, :string, null: true
    add_index :orders, :clover_id
  end
end
