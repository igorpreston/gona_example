class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :location_type, null: false
      t.string :phone
      t.string :email
      t.string :timezone, null: false, default: 'Eastern Time (US & Canada)'
      t.jsonb :schedule, null: true, default: {}
      t.string :pickup_instructions
      t.decimal :tax_rate, null: false, precision: 8, scale: 2, default: 0
      t.string :application_fee_type, null: false
      t.decimal :application_fee_rate, null: false, precision: 8, scale: 2, default: 8
      t.string :currency, null: false, default: 'CAD'
      t.integer :expected_preparation_time_seconds, null: false, default: 0
      t.jsonb :health, null: false, default: {}
      t.integer :menus_count, null: false, default: 0
      t.boolean :auto_accept_order, null: false, default: false
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
