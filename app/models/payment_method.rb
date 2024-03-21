# == Schema Information
#
# Table name: payment_methods
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  default         :boolean          default(FALSE), not null
#  source_type     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#  processor_id    :string           not null
#  user_id         :bigint
#
# Indexes
#
#  index_payment_methods_on_organization_id  (organization_id)
#  index_payment_methods_on_processor_id     (processor_id)
#  index_payment_methods_on_user_id          (user_id)
#
class PaymentMethod < ApplicationRecord
  has_prefix_id :pm, minimum_length: 18

  after_create :touch_organization!, if: -> { organization_id.present? }

  belongs_to :organization, optional: true
  belongs_to :user, optional: true

  has_many :payments
  has_many :payouts

  attribute :routing_number, :string
  attribute :account_number, :string

  store_accessor :data, :stripe_account
  store_accessor :data, :brand # Visa, Mastercard, Discover, PayPal
  store_accessor :data, :last4
  store_accessor :data, :exp_month
  store_accessor :data, :exp_year
  store_accessor :data, :email # PayPal email, etc
  store_accessor :data, :username
  store_accessor :data, :name
  store_accessor :data, :bank_name
  store_accessor :data, :country
  store_accessor :data, :funding # credit, debit, prepaid, unknown
  store_accessor :data, :routing_number
  store_accessor :data, :account_holder_name
  store_accessor :data, :account_holder_type # individual, company
  store_accessor :data, :status # new, validated, verified, verification_failed, errored
  store_accessor :data, :default_for_currency
  store_accessor :data, :status
  store_accessor :data, :currency

  private

  def touch_organization!
    organization.touch
  end
end
