# == Schema Information
#
# Table name: item_modifiers
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  item_id         :bigint           not null
#  modifier_id     :bigint           not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_item_modifiers_on_item_id          (item_id)
#  index_item_modifiers_on_modifier_id      (modifier_id)
#  index_item_modifiers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (modifier_id => modifiers.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class ItemModifier < ApplicationRecord
  has_prefix_id :im, minimum_length: 18

  acts_as_tenant :organization

  belongs_to :item
  belongs_to :modifier

  counter_culture :item, column_name: 'modifiers_count'
  counter_culture :modifier, column_name: 'items_count'
end
