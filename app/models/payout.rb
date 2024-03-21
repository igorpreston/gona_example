# == Schema Information
#
# Table name: payouts
#
#  id                :bigint           not null, primary key
#  amount_cents      :integer
#  currency          :string           default("CAD"), not null
#  data              :jsonb
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  organization_id   :bigint           not null
#  payment_method_id :bigint           not null
#  stripe_payout_id  :string           not null
#
# Indexes
#
#  index_payouts_on_organization_id    (organization_id)
#  index_payouts_on_payment_method_id  (payment_method_id)
#  index_payouts_on_stripe_payout_id   (stripe_payout_id)
#
class Payout < ApplicationRecord
  has_prefix_id :po, minimum_length: 18

  monetize :amount_cents, with_model_currency: :currency

  after_save :publish_payout_failed!, if: -> { saved_change_to_data? && failed? }
  after_save :publish_payout_paid!, if: -> { saved_change_to_data? && paid? }

  acts_as_tenant :organization

  belongs_to :payment_method

  store_accessor :data, :method
  store_accessor :data, :status # paid, pending, in_transit, canceled, failed
  store_accessor :data, :currency
  store_accessor :data, :description
  store_accessor :data, :failure_message
  store_accessor :data, :created
  store_accessor :data, :arrival_date
  store_accessor :data, :statement_descriptor

  def failed?
    status == 'failed'
  end

  def paid?
    status == 'paid'
  end

  def name
    created_at.strftime('%b. %d, %Y')
  end

  private

  def publish_payout_paid!
    publish_event Payout::Paid, id:
  end

  def publish_payout_failed!
    publish_event Payout::Failed, id:, organization_id:
  end
end
