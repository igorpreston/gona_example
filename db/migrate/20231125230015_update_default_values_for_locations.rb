class UpdateDefaultValuesForLocations < ActiveRecord::Migration[7.1]
  def change
    change_column_default :locations, :tax_rate, from: 0.13, to: nil
    change_column_default :locations, :currency, from: 'CAD', to: nil
  end
end
