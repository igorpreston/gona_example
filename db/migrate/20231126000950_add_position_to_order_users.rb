class AddPositionToOrderUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :order_users, :position, :integer, default: 0, null: false
  end
end
