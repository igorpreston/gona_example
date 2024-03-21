class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :organization, index: true, foreign_key: true
      t.string :status
      t.string :interval
      t.string :stripe_plan_id
      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      t.integer :quantity
      t.datetime :canceled_at
      t.datetime :trial_starts_at
      t.datetime :trial_ends_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
