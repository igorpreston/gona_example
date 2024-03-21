class AddDeletedAtToLocations < ActiveRecord::Migration[7.1]
  def up
    add_column :locations, :deleted_at, :datetime
    add_index :locations, :deleted_at
  end

  def down
    remove_index :locations, :deleted_at
    remove_column :locations, :deleted_at
  end
end
