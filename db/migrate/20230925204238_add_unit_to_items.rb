class AddUnitToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :unit, :string, default: 'ea', null: false
  end
end
