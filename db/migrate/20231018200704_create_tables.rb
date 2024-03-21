class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :tables do |t|
      t.belongs_to :organization, null: false
      t.belongs_to :location, null: false
      t.string :name
      t.integer :position, default: 0
      t.integer :capacity
      t.string :square_id

      t.timestamps
    end
  end
end
