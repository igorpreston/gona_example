class CreateMenuCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_categories do |t|
      t.belongs_to :menu, null: false, foreign_key: true
      t.belongs_to :category, null: false, foreign_key: true
      t.boolean :published, null: false, default: false
      t.integer :items_count, null: false, default: 0
      t.integer :position, null: false, default: 0
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :menu_categories, %w[menu_id category_id], unique: true
  end
end
