class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods do |t|
      t.belongs_to :organization, null: true, index: true
      t.belongs_to :user, null: true, index: true
      t.string :processor_id, null: false, index: true, unique: true
      t.boolean :default, null: false, default: false
      t.string :source_type
      t.jsonb :data

      t.timestamps
    end
  end
end
