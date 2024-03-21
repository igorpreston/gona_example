class AddPaymentSplitTypeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_split_type, :string
    add_column :orders, :number_of_people, :integer, default: 1
  end
end
