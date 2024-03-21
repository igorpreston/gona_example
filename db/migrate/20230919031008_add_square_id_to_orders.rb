class AddSquareIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :square_id, :string, null: true, index: true, unique: true
  end
end
