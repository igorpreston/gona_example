class UpdateUserOnNotes < ActiveRecord::Migration[7.0]
  def up
    change_column_null :notes, :user_id, true
  end

  def down
    change_column_null :notes, :user_id, true
  end
end
