class CreateModifiers < ActiveRecord::Migration[7.0]
  def change
    create_table :modifiers do |t|
      t.string :name, null: false
      t.boolean :required, default: false
      t.integer :min_select, default: 0
      t.integer :max_select, default: 1
      t.integer :max_option_select, default: 1
      t.integer :options_count, default: 0
      t.integer :items_count, default: 0
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
