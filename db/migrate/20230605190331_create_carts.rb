class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.references :user, null: true, index: true
      t.integer :draft_orders_count, null: false, default: 0

      t.timestamps
    end
  end
end
