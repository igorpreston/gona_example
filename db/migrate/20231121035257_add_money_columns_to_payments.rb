class AddMoneyColumnsToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :subtotal_cents, :integer, default: 0
    add_column :payments, :tax_cents, :integer, default: 0
    add_column :payments, :tip_cents, :integer, default: 0
    add_column :payments, :application_fee_cents, :integer, default: 0
    add_column :payments, :application_fee_tax_cents, :integer, default: 0
    add_column :payments, :application_fee_math, :string

    remove_column :payments, :amount_details, :jsonb
  end
end
