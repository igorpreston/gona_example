class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :stripe_payment_intent_id, null: true, index: true, unique: true
      t.string :status, null: false
      t.string :currency, null: false, default: 'CAD'
      t.integer :amount_cents, null: false, default: 0
      t.jsonb :amount_details, null: false, default: {}
      t.jsonb :latest_charge_data, null: false, default: {}
      t.string :receipt_number, null: true
      t.datetime :cancelled_at, null: true
      t.datetime :refunded_at, null: true
      t.datetime :failed_at, null: true
      t.datetime :paid_at, null: true
      t.belongs_to :order, null: true, index: true
      t.belongs_to :user, null: true, index: true
      t.belongs_to :payment_method, null: true, index: true
      t.belongs_to :organization, null: false, idnex: true

      t.timestamps
    end
  end
end
