class CreateLocationMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :location_menus do |t|
      t.belongs_to :location, null: false, foreign_key: true
      t.belongs_to :menu, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
