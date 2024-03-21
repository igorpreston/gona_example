class AddSquareIdToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :square_id, :string
    add_index :categories, :square_id, unique: true
  end
end
