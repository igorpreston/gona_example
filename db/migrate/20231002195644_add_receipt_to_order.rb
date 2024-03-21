class AddReceiptToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :receipt_number, :string, index: true
  end
end
