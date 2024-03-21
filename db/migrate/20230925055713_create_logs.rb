class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :type, null: false
      t.jsonb :data, null: false, default: {}
      t.string :message_key, null: false
      t.string :scope, null: false
      t.belongs_to :order, null: true, index: true

      t.timestamps
    end
  end
end
