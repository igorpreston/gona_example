class AddPositionToLocationMenus < ActiveRecord::Migration[7.1]
  def change
    add_column :location_menus, :position, :integer, null: false, default: 0
  end
end
