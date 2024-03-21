class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.integer :quantity, null: false, default: 1
      t.belongs_to :order, null: false, foreign_key: true, index: true
      t.belongs_to :item, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
