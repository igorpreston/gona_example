class CreateMenuCategoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_category_items do |t|
      t.belongs_to :menu_category, null: false, foreign_key: true
      t.belongs_to :item, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :menu_category_items, %w[menu_category_id item_id], unique: true
  end
end
