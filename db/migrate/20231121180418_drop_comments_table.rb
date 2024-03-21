class DropCommentsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :comments do |t|
      # Add any options or columns here if needed
    end
  end
end
