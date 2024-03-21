class AddDataToSuggestions < ActiveRecord::Migration[7.1]
  def change
    add_column :suggestions, :data, :jsonb, default: {}, null: false
  end
end
