class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.integer :position, null: false, default: 0
      t.belongs_to :option, null: true, index: true
      t.belongs_to :modifier, null: true, index: true
      t.belongs_to :item, null: true, index: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
