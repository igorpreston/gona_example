class AddOrderUserToPayments < ActiveRecord::Migration[7.1]
  def change
    add_reference :payments, :order_user, null: true, foreign_key: true, index: true
  end
end
