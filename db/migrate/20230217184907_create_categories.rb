class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.jsonb :health, null: false, default: {}
      t.integer :items_count, default: 0
      t.integer :menus_count, default: 0
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
