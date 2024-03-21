class CreateItemModifiers < ActiveRecord::Migration[7.0]
  def change
    create_table :item_modifiers do |t|
      t.belongs_to :item, null: false, foreign_key: true
      t.belongs_to :modifier, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
