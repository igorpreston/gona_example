class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price_cents, default: 0
      t.string :currency, default: 'CAD', null: false
      t.boolean :sold_out, default: false, null: false
      t.string :source, null: false
      t.string :internal_tags, array: true, default: [], null: true
      t.jsonb :metadata, null: false, default: {}
      t.integer :menus_count, null: false, default: 0
      t.integer :modifiers_count, null: false, default: 0
      t.datetime :deleted_at, index_static: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
