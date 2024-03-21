class AddCloverIdToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :clover_id, :string
  end
end
