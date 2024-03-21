# == Schema Information
#
# Table name: qr_codes
#
#  id              :bigint           not null, primary key
#  code            :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :bigint
#  organization_id :bigint           not null
#  table_id        :bigint
#
# Indexes
#
#  index_qr_codes_on_location_id      (location_id)
#  index_qr_codes_on_organization_id  (organization_id)
#  index_qr_codes_on_table_id         (table_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class QrCode < ApplicationRecord
  has_prefix_id :qr, minimum_length: 18

  acts_as_tenant :organization

  belongs_to :location, optional: true
  belongs_to :table, optional: true

  has_many :logs, dependent: :destroy

  before_create :generate_code!, if: -> { code.blank? }
  before_destroy :destroy_label!

  after_commit :publish_create!, on: :create

  has_one_attached :label, dependent: :destroy

  def generate_code!
    self.code = loop do
      random_token = SecureRandom.hex(4)
      break random_token unless self.class.exists?(code: random_token)
    end
  end

  private

  def publish_create!
    publish_event QrCode::Created, id:
  end

  def destroy_label!
    label&.purge
  end
end
