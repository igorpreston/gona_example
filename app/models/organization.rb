# == Schema Information
#
# Table name: organizations
#
#  id                         :bigint           not null, primary key
#  application_fee_math       :string           not null
#  application_fee_rate       :decimal(5, 2)
#  application_fee_type       :string
#  business_category          :string           not null
#  business_number            :string
#  business_type              :string           not null
#  charges_enabled            :boolean          default(FALSE), not null
#  currency                   :string           not null
#  deleted_at                 :datetime
#  description                :string
#  details_submitted          :boolean          default(FALSE)
#  email                      :string
#  feedbacks_count            :integer          default(0), not null
#  health                     :jsonb            not null
#  legal_name                 :string
#  name                       :string           not null
#  nickname                   :string
#  payouts_enabled            :boolean          default(FALSE), not null
#  phone                      :string
#  product_details            :text
#  status                     :string           not null
#  unread_notifications_count :integer          default(0), not null
#  website                    :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  clover_id                  :string
#  owner_id                   :bigint           not null
#  square_id                  :string
#  stripe_account_id          :string
#  stripe_customer_id         :string
#
# Indexes
#
#  index_organizations_on_name      (name)
#  index_organizations_on_nickname  (nickname)
#  index_organizations_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => merchants.id)
#
class Organization < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: Organization::Transition,
    initial_state: :onboarding,
    transition_name: :transitions
  ]

  DESCRIPTION_LENGTH = 280
  WEBSITE_REGEXP = %r{\A(?:https?://)?(?:www\.)?(?:[a-zA-Z0-9_-]+\.)*[a-zA-Z0-9_-]+\.[a-zA-Z]{2,}(?:/[^\s]*)?\z}
  NICKNAME_REGEXP = /\A[a-zA-Z0-9_]+\z/
  APPLICATION_FEE_RATE_MIN = 0.0
  APPLICATION_FEE_RATE_MAX = 1.0
  APPLICATION_FEE_RATE_DEFAULT = 0.03

  has_prefix_id :org, minimum_length: 12

  has_one_attached :logo, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy

  before_validation :default_values, on: :create

  after_commit :publish_created!, on: :create
  after_commit :publish_health_checked!, on: :update, if: -> { charges_enabled_changed? }
  after_commit :publish_onboarding_task_completed!, on: :update, if: -> { onboarding? } # via touch organization

  belongs_to :owner, class_name: Merchant.name, optional: true

  has_one :onboarding, dependent: :destroy
  has_one :address, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :merchants, dependent: :nullify
  has_many :transitions, autosave: false, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many :menu_categories, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :payouts, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :qr_codes, dependent: :destroy
  has_many :modifiers, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :integrations, dependent: :destroy
  has_many :tables, dependent: :destroy

  enum business_type: {
    restaurant: 'restaurant'
  }, _default: 'restaurant'

  enum application_fee_type: {
    included_per_order: 'included_per_order',
    added_per_order: 'added_per_order',
    subscription: 'subscription'
  }, _default: 'included_per_order'

  enum application_fee_math: {
    fee_included: 'fee_included',
    fee_added: 'fee_added'
  }, _default: 'fee_included'

  enum business_category: {
    company: 'company',
    nonprofit: 'nonprofit'
  }, _default: 'company'

  enum status: {
    onboarding: 'onboarding',
    disabled: 'disabled',
    active: 'active'
  }, _default: 'onboarding'

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank, update_only: true
  accepts_nested_attributes_for :owner, reject_if: :all_blank, update_only: true

  phony_normalize :phone, default_country_code: Rails.application.config.country

  validates :name, presence: true
  validates :nickname, format: { with: NICKNAME_REGEXP }, allow_blank: true
  validates :currency, presence: true, inclusion: { in: Rails.application.config.currencies }
  validates :business_type, presence: true, inclusion: { in: business_types.keys }
  validates :business_category, presence: true, inclusion: { in: business_categories.keys }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :description, length: { maximum: DESCRIPTION_LENGTH }, allow_blank: true
  validates :website, format: { with: WEBSITE_REGEXP }, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
  validates :square_id, uniqueness: { allow_blank: true }, if: :square_id?
  validates :clover_id, uniqueness: { allow_blank: true }, if: :clover_id?

  def state_machine
    @state_machine ||= Organization::StateMachine.new(
      self,
      transition_class: Organization::Transition,
      association_name: :transitions
    )
  end

  def card
    payment_methods.find_by(default: true, source_type: 'card')
  end

  def bank
    payment_methods.find_by(default: true, source_type: 'bank_account')
  end

  def subscription
    subscriptions.find_by(status: 'active')
  end

  def square
    integrations.find_by(type: Integration::Square.name)
  end

  def clover
    integrations.find_by(type: Integration::Clover.name)
  end

  def integrated_with?(app)
    integrations.exists?(app:)
  end

  private

  def publish_created!
    publish_event Organization::Created, id:
  end

  def publish_onboarding_task_completed!
    publish_event Organization::OnboardingTaskCompleted, id:
  end

  def publish_health_checked!
    publish_event Organization::HealthChecked, id:
  end

  def default_values
    self.application_fee_rate ||= APPLICATION_FEE_RATE_DEFAULT
    self.currency ||= Rails.application.config.currency
  end
end
