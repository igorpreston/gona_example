class AddModifiersCountToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :modifiers_count, :integer, default: 0, null: false
  end
end
