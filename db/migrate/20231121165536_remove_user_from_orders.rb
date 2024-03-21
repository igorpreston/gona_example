class RemoveUserFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_reference :orders, :user
  end
end
