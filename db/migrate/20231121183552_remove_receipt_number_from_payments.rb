class RemoveReceiptNumberFromPayments < ActiveRecord::Migration[7.1]
  def up
    remove_column :payments, :receipt_number
  end

  def down
    add_column :payments, :receipt_number, :string
  end
end
