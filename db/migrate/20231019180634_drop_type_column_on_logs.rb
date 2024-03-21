class DropTypeColumnOnLogs < ActiveRecord::Migration[7.0]
  def up
    remove_column :logs, :type
  end

  def down
    add_column :logs, :type, :string
  end
end
