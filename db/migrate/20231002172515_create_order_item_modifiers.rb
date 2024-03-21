class CreateOrderItemModifiers < ActiveRecord::Migration[7.0]
  def change
    create_table :order_item_modifiers do |t|
      t.belongs_to :order_item, null: false, foreign_key: true
      t.belongs_to :modifier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
