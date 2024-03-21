class CreateCategoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :category_items do |t|
      t.integer :position, null: false, default: 0
      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :item, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
