class DropPriceCentsOnOrderItemModifiers < ActiveRecord::Migration[7.1]
  def change
    remove_column :order_item_modifiers, :price_cents, :integer, null: false, default: 0
    remove_column :order_item_modifiers, :currency, :string, null: false, default: 'CAD'
  end
end
