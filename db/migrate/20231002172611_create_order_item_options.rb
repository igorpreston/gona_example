class CreateOrderItemOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :order_item_options do |t|
      t.belongs_to :order_item_modifier, null: false, foreign_key: true
      t.belongs_to :option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
