# == Schema Information
#
# Table name: locations
#
#  id                                :bigint           not null, primary key
#  auto_accept_order                 :boolean          default(FALSE), not null
#  currency                          :string           not null
#  deleted_at                        :datetime
#  email                             :string
#  expected_preparation_time_seconds :integer          default(0), not null
#  feedbacks_count                   :integer          default(0), not null
#  health                            :jsonb            not null
#  location_type                     :string           not null
#  menus_count                       :integer          default(0), not null
#  name                              :string           not null
#  phone                             :string
#  pickup_instructions               :string
#  rating                            :decimal(4, 2)    default(0.0), not null
#  schedule                          :jsonb
#  tables_count                      :integer          default(0), not null
#  tax_rate                          :decimal(8, 2)    not null
#  timezone                          :string           default("Eastern Time (US & Canada)"), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  organization_id                   :bigint           not null
#  square_id                         :string
#
# Indexes
#
#  index_locations_on_deleted_at       (deleted_at)
#  index_locations_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Location < ApplicationRecord
  TAX_RATE_MIN = 0.0
  TAX_RATE_MAX = 1.0
  DEFAULT_TAX_RATE = 0.13

  has_prefix_id :loc, minimum_length: 12

  acts_as_paranoid

  acts_as_tenant :organization, touch: true

  before_validation :default_values, on: :create

  before_create :default_values

  after_commit :publish_created!, on: :create

  has_one :address, dependent: :destroy
  has_one :qr_code, dependent: :destroy

  has_many :feedbacks, dependent: :destroy
  has_many :location_menus, dependent: :destroy
  has_many :menus, through: :location_menus
  has_many :orders
  has_many :current_menus, -> { merge(Menu.current) }, through: :location_menus, source: :menu
  has_many :tables, dependent: :destroy

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  # keep this before accepts_nested_attributes_for, otherwise it will break the attributes
  include Scheduleable

  enum location_type: {
    physical: 'physical',
    mobile: 'mobile'
  }, _default: 'physical'

  phony_normalize :phone, default_country_code: Rails.application.config.country

  validates :name, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: TAX_RATE_MIN, less_than_or_equal_to: TAX_RATE_MAX }
  validates :timezone, presence: true, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  validates :location_type, presence: true, inclusion: { in: location_types.keys }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :square_id, uniqueness: { allow_blank: true }, if: :square_id?

  def active?
    menus_count.positive? && address.present?
  end

  def ready_in_minutes?
    (expected_preparation_time_seconds / 60) || 0
  end

  def integration?
    square_id?
  end

  def pos_integration_type
    if square_id?
      'square'
    else
      'stripe'
    end
  end

  def update_rating!
    update_column :rating, feedbacks.where(
      created_at: 1.month.ago..Time.current
    ).where.not(
      rating: 0
    ).average(:rating).to_f
  end

  private

  def publish_created!
    publish_event Location::Created, id:
  end

  def default_values
    self.tax_rate ||= DEFAULT_TAX_RATE
    self.currency ||= organization.currency
  end
end
