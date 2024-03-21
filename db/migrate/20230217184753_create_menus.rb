class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.string :description
      t.jsonb :schedule, null: true, default: {}
      t.boolean :published, null: false, default: false
      t.integer :items_count, null: false, default: 0
      t.integer :active_items_count, null: false, default: 0
      t.integer :categories_count, null: false, default: 0
      t.integer :locations_count, null: false, default: 0
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
