class AddRatesToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :application_fee_type, :string
    add_column :organizations, :application_fee_rate, :decimal, precision: 5, scale: 2, default: 0.0, null: true
    add_column :organizations, :application_fee_math, :string, null: false, default: 'fee_included'
  end
end
