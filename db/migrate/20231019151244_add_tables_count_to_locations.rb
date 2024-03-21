class AddTablesCountToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :tables_count, :integer, null: false, default: 0
  end
end
