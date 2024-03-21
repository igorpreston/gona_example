# == Schema Information
#
# Table name: category_items
#
#  id              :bigint           not null, primary key
#  position        :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  category_id     :bigint           not null
#  item_id         :bigint           not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_category_items_on_category_id      (category_id)
#  index_category_items_on_item_id          (item_id)
#  index_category_items_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class CategoryItem < ApplicationRecord
  has_prefix_id :ci, minimum_length: 18

  acts_as_list scope: :category
  acts_as_tenant :organization

  belongs_to :category
  belongs_to :item

  counter_culture :category, column_name: 'items_count'
end
