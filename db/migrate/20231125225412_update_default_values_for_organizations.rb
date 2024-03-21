class UpdateDefaultValuesForOrganizations < ActiveRecord::Migration[7.1]
  def change
    change_column_default :organizations, :application_fee_rate, from: 0.0, to: nil
    change_column_default :organizations, :application_fee_math, from: 'fee_included', to: nil
    change_column_default :organizations, :currency, from: 'CAD', to: nil
  end
end
