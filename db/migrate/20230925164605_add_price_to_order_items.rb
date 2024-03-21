class AddPriceToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :price_cents, :integer, default: 0, null: false
    add_column :order_items, :currency, :string, default: 'CAD', null: false
  end
end
