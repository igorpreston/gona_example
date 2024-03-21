# == Schema Information
#
# Table name: menu_category_items
#
#  id               :bigint           not null, primary key
#  position         :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  item_id          :bigint           not null
#  menu_category_id :bigint           not null
#  organization_id  :bigint           not null
#
# Indexes
#
#  index_menu_category_items_on_item_id                       (item_id)
#  index_menu_category_items_on_menu_category_id              (menu_category_id)
#  index_menu_category_items_on_menu_category_id_and_item_id  (menu_category_id,item_id) UNIQUE
#  index_menu_category_items_on_organization_id               (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (menu_category_id => menu_categories.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class MenuCategoryItem < ApplicationRecord
  has_prefix_id :mci, minimum_length: 18

  acts_as_tenant :organization

  belongs_to :menu_category
  belongs_to :item

  has_one :category, through: :menu_category
  has_one :menu, through: :menu_category

  has_many :modifiers, through: :item

  counter_culture :item, column_name: 'menus_count'
  counter_culture :menu_category, column_name: 'items_count'

  acts_as_list scope: :menu_category

  accepts_nested_attributes_for :item

  delegate :prefix_id, to: :item, prefix: true
  delegate :name, to: :item, prefix: true
  delegate :description, to: :item, prefix: true
  delegate :photo, to: :item, prefix: true
  delegate :price_formatted, to: :item, prefix: true

  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def to_s
    item_name
  end
end
