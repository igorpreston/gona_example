class CreatePayouts < ActiveRecord::Migration[7.0]
  def change
    create_table :payouts do |t|
      t.belongs_to :organization, null: false, index: true
      t.belongs_to :payment_method, null: false, index: true
      t.string :stripe_payout_id, null: false, index: true, unique: true
      t.integer :amount_cents
      t.string :currency, default: "CAD", null: false
      t.jsonb :data
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
