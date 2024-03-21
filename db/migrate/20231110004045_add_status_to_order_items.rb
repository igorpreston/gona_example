class AddStatusToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :status, :string, null: false, default: :paid
  end
end
