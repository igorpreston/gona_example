class AddOwnerToOrganizations < ActiveRecord::Migration[7.0]
  def up
    add_reference :organizations, :owner, null: false, foreign_key: { to_table: :users }
  end

  def down
    remove_reference :organizations, :owner
  end
end
