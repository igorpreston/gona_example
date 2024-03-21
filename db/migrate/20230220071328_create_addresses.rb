class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :line_one
      t.string :line_two
      t.string :line_three
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.float :latitude, index: true
      t.float :longitude, index: true
      t.boolean :default, default: false
      t.belongs_to :organization, null: true, index: true
      t.belongs_to :user, null: true, index: true
      t.belongs_to :location, null: true, index: true

      t.timestamps
    end
  end
end
