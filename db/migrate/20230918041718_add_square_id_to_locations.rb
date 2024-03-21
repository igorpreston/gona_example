class AddSquareIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :square_id, :string, null: true, default: nil, index: true, unique: true
  end
end
