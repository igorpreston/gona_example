# == Schema Information
#
# Table name: integrations
#
#  id              :bigint           not null, primary key
#  configs         :jsonb            not null
#  type            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  app_id          :bigint
#  organization_id :bigint           not null
#
# Indexes
#
#  index_integrations_on_app_id           (app_id)
#  index_integrations_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (app_id => apps.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class Integration < ApplicationRecord
  INTEGRATION_TYPES = {
    square: Integration::Square,
    clover: Integration::Clover
  }.freeze

  has_prefix_id :int, minimum_length: 18

  belongs_to :organization, touch: true
  belongs_to :app
end
