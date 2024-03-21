# == Schema Information
#
# Table name: addresses
#
#  id              :bigint           not null, primary key
#  city            :string
#  country         :string
#  default         :boolean          default(FALSE)
#  latitude        :float
#  line_one        :string
#  line_three      :string
#  line_two        :string
#  longitude       :float
#  name            :string
#  state           :string
#  zip             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :bigint
#  organization_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_addresses_on_latitude         (latitude)
#  index_addresses_on_location_id      (location_id)
#  index_addresses_on_longitude        (longitude)
#  index_addresses_on_organization_id  (organization_id)
#  index_addresses_on_user_id          (user_id)
#
class Address < ApplicationRecord
  has_prefix_id :adr, minimum_length: 18

  geocoded_by :zip

  before_validation :format_zip!, if: -> { zip.present? and country.present? }

  after_save :touch_organization!, if: -> { organization_id.present? }

  belongs_to :location, optional: true
  belongs_to :organization, optional: true
  belongs_to :user, optional: true

  after_validation :geocode, if: -> { address_changed? && coordinates_blank? }

  enum :name, {
    home: 'home',
    work: 'work',
    billing: 'billing',
    shipping: 'shipping'
  }, _default: 'billing'

  validates :line_one, presence: true, allow_blank: true
  validates :zip, allow_blank: true, zipcode: { country_code_attribute: :country, format: true }
  validates :country, presence: true, inclusion: { in: Rails.application.config.countries }

  attr_accessor :address

  def to_s
    [line_one, line_two, line_three, city, state, zip, country].reject(&:blank?).join(', ')
  end

  def google_maps_url
    "https://www.google.com/maps/search/?api=1&query=#{latitude},#{longitude}"
  end

  private

  def address_changed?
    line_one_changed? || line_two_changed? || line_three_changed? || city_changed? || state_changed? || zip_changed? || country_changed?
  end

  def coordinates_blank?
    longitude.blank? && latitude.blank?
  end

  def format_zip!
    self.zip = ValidatesZipcode::Formatter.new(zipcode: zip, country_alpha2: country).format
  end

  def touch_organization!
    organization.touch
  end
end
