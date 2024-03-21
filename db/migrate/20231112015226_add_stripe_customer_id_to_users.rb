class AddStripeCustomerIdToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :stripe_customer_id, :string, null: true
    add_index :users, :stripe_customer_id
  end

  def down
    remove_index :users, :stripe_customer_id
    remove_column :users, :stripe_customer_id
  end
end
