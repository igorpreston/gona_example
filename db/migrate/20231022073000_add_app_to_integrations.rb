class AddAppToIntegrations < ActiveRecord::Migration[7.0]
  def change
    add_reference :integrations, :app, index: true, foreign_key: true
  end
end
