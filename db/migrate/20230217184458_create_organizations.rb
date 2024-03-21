class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :legal_name
      t.string :name, null: false, index: true
      t.string :nickname, index: true, unique: true, null: true
      t.string :status, null: false
      t.string :description
      t.string :business_number
      t.string :currency, default: "CAD", null: false
      t.string :email
      t.string :phone
      t.string :website
      t.string :business_category, null: false
      t.string :business_type, null: false
      t.string :stripe_customer_id, unique: true, null: true
      t.string :stripe_account_id, unique: true, null: true
      t.text :product_details
      t.jsonb :health, default: {}, null: false
      t.integer :feedbacks_count, default: 0, null: false
      t.integer :unread_notifications_count, default: 0, null: false
      t.boolean :payouts_enabled, null: false, default: false
      t.boolean :charges_enabled, null: false, default: false
      t.datetime :deleted_at, index_static: true

      t.timestamps
    end
  end
end
