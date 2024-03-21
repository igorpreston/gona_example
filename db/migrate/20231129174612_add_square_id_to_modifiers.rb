class AddSquareIdToModifiers < ActiveRecord::Migration[7.1]
  def change
    add_column :modifiers, :square_id, :string
    add_index :modifiers, :square_id, unique: true
  end
end
