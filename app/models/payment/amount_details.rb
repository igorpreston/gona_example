class Payment::AmountDetails
  include StoreModel::Model

  attribute :subtotal_cents, :integer, default: 0
  attribute :tax_cents, :integer, default: 0
  attribute :tip_cents, :integer, default: 0
  attribute :application_fee_cents, :integer, default: 0
  attribute :application_fee_rate, :decimal, default: 0.0
  attribute :application_fee_math, :string, default: 'included'
  attribute :application_fee_tax_cents, :integer, default: 0
  attribute :application_fee_total_cents, :integer, default: 0
end
