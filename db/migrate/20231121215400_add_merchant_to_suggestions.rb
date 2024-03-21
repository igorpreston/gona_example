class AddMerchantToSuggestions < ActiveRecord::Migration[7.1]
  def up
    add_reference :suggestions, :merchant, null: true
    change_column :suggestions, :user_id, :integer, null: true
  end

  def down
    remove_reference :suggestions, :merchant
    change_column :suggestions, :user_id, :integer, null: true
  end
end
