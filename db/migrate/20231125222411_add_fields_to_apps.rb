class AddFieldsToApps < ActiveRecord::Migration[7.1]
  def change
    add_column :apps, :name, :string
    add_column :apps, :description, :text
    add_column :apps, :metadata, :jsonb, default: {}
  end
end
