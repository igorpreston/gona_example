class AddPriceCentsToOrderItemOptions < ActiveRecord::Migration[7.1]
  def change
    add_column :order_item_options, :price_cents, :integer, null: false, default: 0
    add_column :order_item_options, :currency, :string, null: false, default: 'CAD'

    add_index :order_item_options, :price_cents
  end
end
