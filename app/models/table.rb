# == Schema Information
#
# Table name: tables
#
#  id              :bigint           not null, primary key
#  capacity        :integer
#  name            :string
#  position        :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :bigint           not null
#  organization_id :bigint           not null
#  square_id       :string
#
# Indexes
#
#  index_tables_on_location_id      (location_id)
#  index_tables_on_organization_id  (organization_id)
#
class Table < ApplicationRecord
  has_prefix_id :tbl, minimum_length: 20

  after_create :publish_created!

  acts_as_tenant :organization

  belongs_to :location

  has_one :qr_code, dependent: :destroy

  has_many :orders

  counter_culture :location, column_name: 'tables_count'

  acts_as_list scope: :location

  private

  def publish_created!
    publish_event Table::Created, id:
  end
end
