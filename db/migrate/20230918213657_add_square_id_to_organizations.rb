class AddSquareIdToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :square_id, :string, null: true, index: true, unique: true
  end
end
