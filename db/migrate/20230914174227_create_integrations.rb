class CreateIntegrations < ActiveRecord::Migration[7.0]
  def change
    create_table :integrations do |t|
      t.belongs_to :organization, null: false, foreign_key: true, index: true
      t.string :type, null: false
      t.jsonb :configs, null: false, default: {}

      t.timestamps
    end
  end
end
