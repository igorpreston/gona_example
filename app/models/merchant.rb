# == Schema Information
#
# Table name: merchants
#
#  id                     :bigint           not null, primary key
#  color                  :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  dob                    :date
#  email                  :string           default("")
#  encrypted_password     :string           default("")
#  first_name             :string           default("")
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string           default("")
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  phone                  :string           default("")
#  policies               :jsonb            not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#  organization_id        :bigint
#  stripe_customer_id     :string
#  stripe_person_id       :string           default("")
#
# Indexes
#
#  index_merchants_on_email               (email)
#  index_merchants_on_invitation_token    (invitation_token) UNIQUE
#  index_merchants_on_invited_by_id       (invited_by_id)
#  index_merchants_on_organization_id     (organization_id)
#  index_merchants_on_phone               (phone)
#  index_merchants_on_stripe_customer_id  (stripe_customer_id)
#  index_users_on_invited_by              (invited_by_type,invited_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Merchant < ApplicationRecord
  has_prefix_id :mrch, minimum_length: 18

  has_person_name

  before_validation :set_color, unless: :color?

  belongs_to :organization, optional: true
  belongs_to :invited_by, polymorphic: true, optional: true

  has_many :suggestions, dependent: :destroy

  has_one_attached :avatar, dependent: :destroy

  attr_accessor :day, :month, :year

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable,
         :validatable

  enum role: {
    owner: 'owner',
    user: 'user'
  }, _default: 'user'

  enum color: {
    slate: 'slate',
    orange: 'orange',
    emerald: 'emerald',
    teal: 'teal',
    sky: 'sky',
    indigo: 'indigo',
    pink: 'pink',
    rose: 'rose'
  }

  phony_normalize :phone, default_country_code: Rails.application.config.country

  validates :first_name, presence: true, unless: -> { invitation_sent_at? }
  validates :last_name, presence: true, unless: -> { invitation_sent_at? }
  validates :role, inclusion: { in: roles.keys }
  validates :color, presence: true, inclusion: { in: colors.keys }
  # validates_plausible_phone :phone, uniqueness: true, allow_blank: true

  def invitation_sent?
    invitation_sent_at? && invitation_accepted_at.nil?
  end

  private

  def set_color
    self.color = self.class.colors.keys.sample
  end
end
