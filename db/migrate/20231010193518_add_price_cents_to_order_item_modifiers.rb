class AddPriceCentsToOrderItemModifiers < ActiveRecord::Migration[7.0]
  def change
    add_column :order_item_modifiers, :price_cents, :integer, default: 0, null: false
    add_column :order_item_modifiers, :currency, :string, default: 'CAD', null: false
  end
end
