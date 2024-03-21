class AddHandlerToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :handler, :string, null: false
  end
end
