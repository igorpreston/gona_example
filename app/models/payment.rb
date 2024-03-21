# == Schema Information
#
# Table name: payments
#
#  id                        :bigint           not null, primary key
#  amount_cents              :integer          default(0), not null
#  application_fee_cents     :integer          default(0)
#  application_fee_math      :string
#  application_fee_tax_cents :integer          default(0)
#  cancelled_at              :datetime
#  currency                  :string           default("CAD"), not null
#  failed_at                 :datetime
#  latest_charge_data        :jsonb            not null
#  paid_at                   :datetime
#  refunded_at               :datetime
#  status                    :string           not null
#  subtotal_cents            :integer          default(0)
#  tax_cents                 :integer          default(0)
#  tip_cents                 :integer          default(0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  order_id                  :bigint
#  order_user_id             :bigint
#  organization_id           :bigint           not null
#  payment_method_id         :bigint
#  square_id                 :string
#  stripe_payment_intent_id  :string
#  user_id                   :bigint
#
# Indexes
#
#  index_payments_on_order_id                  (order_id)
#  index_payments_on_order_user_id             (order_user_id)
#  index_payments_on_organization_id           (organization_id)
#  index_payments_on_payment_method_id         (payment_method_id)
#  index_payments_on_stripe_payment_intent_id  (stripe_payment_intent_id)
#  index_payments_on_user_id                   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_user_id => order_users.id)
#
class Payment < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: Payment::Transition,
    initial_state: :created,
    transition_name: :transitions
  ]

  has_prefix_id :pm, minimum_length: 18

  after_commit :publish_refunded!, on: :update, if: -> { saved_change_to_status? and refunded? }

  monetize :amount_cents, with_model_currency: :currency
  monetize :application_fee_cents, with_model_currency: :currency
  monetize :application_fee_tax_cents, with_model_currency: :currency
  monetize :subtotal_cents, with_model_currency: :currency
  monetize :tax_cents, with_model_currency: :currency
  monetize :tip_cents, with_model_currency: :currency

  belongs_to :organization
  belongs_to :order, optional: true
  belongs_to :user, optional: true
  belongs_to :payment_method, optional: true
  belongs_to :order_user, optional: true

  has_many :transitions, autosave: false

  enum status: {
    created: 'created',
    uncaptured: 'uncaptured',
    paid: 'paid',
    partially_refunded: 'partially_refunded',
    refunded: 'refunded',
    failed: 'failed',
    cancelled: 'cancelled'
  }, _default: 'created'

  store_accessor :latest_charge_data, :payment_method_details
  store_accessor :latest_charge_data, :outcome

  validates :currency, presence: true, inclusion: { in: Rails.application.config.currencies }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  def state_machine
    @state_machine ||= Payment::StateMachine.new(
      self,
      transition_class: Payment::Transition,
      association_name: :transitions
    )
  end

  def to_stripe_charge!
    ::Stripe::PaymentIntent.capture(stripe_payment_intent_id, {}, { stripe_account: organization.stripe_account_id })
  rescue ::Stripe::StripeError => e
    Rails.logger.error "[#{self.class.name}##{__method__}] #{e.message}"
  end

  private

  def publish_refunded!
    publish_event Payment::Refunded, id:
  end
end
