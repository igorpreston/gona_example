# == Schema Information
#
# Table name: location_menus
#
#  id              :bigint           not null, primary key
#  position        :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :bigint           not null
#  menu_id         :bigint           not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_location_menus_on_location_id      (location_id)
#  index_location_menus_on_menu_id          (menu_id)
#  index_location_menus_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (menu_id => menus.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class LocationMenu < ApplicationRecord
  has_prefix_id :lm, minimum_length: 18

  acts_as_tenant :organization

  belongs_to :location
  belongs_to :menu

  acts_as_list scope: :location

  counter_culture :menu, column_name: 'locations_count'
  counter_culture :location, column_name: 'menus_count'
end
