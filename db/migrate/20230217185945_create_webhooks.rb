class CreateWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :webhooks do |t|
      t.string :source
      t.string :data_type
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end
  end
end
