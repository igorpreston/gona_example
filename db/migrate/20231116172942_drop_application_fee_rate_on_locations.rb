class DropApplicationFeeRateOnLocations < ActiveRecord::Migration[7.1]
  def change
    remove_column :locations, :application_fee_rate, :decimal, precision: 5, scale: 2
    remove_column :locations, :application_fee_type, :string
  end
end
