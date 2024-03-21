class AddDetailsSubmittedToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :details_submitted, :boolean, default: false
  end
end
