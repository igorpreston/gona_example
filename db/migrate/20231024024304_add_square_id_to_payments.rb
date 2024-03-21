class AddSquareIdToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :square_id, :string
  end
end
