class AddSquareIdToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :square_id, :string, null: true, default: nil, index: true, unique: true
  end
end
