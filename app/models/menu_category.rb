# == Schema Information
#
# Table name: menu_categories
#
#  id              :bigint           not null, primary key
#  items_count     :integer          default(0), not null
#  position        :integer          default(0), not null
#  published       :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  category_id     :bigint           not null
#  menu_id         :bigint           not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_menu_categories_on_category_id              (category_id)
#  index_menu_categories_on_menu_id                  (menu_id)
#  index_menu_categories_on_menu_id_and_category_id  (menu_id,category_id) UNIQUE
#  index_menu_categories_on_organization_id          (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (menu_id => menus.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class MenuCategory < ApplicationRecord
  has_prefix_id :mc, minimum_length: 18

  acts_as_tenant :organization

  belongs_to :menu
  belongs_to :category

  has_many :menu_category_items, -> { order(position: :asc) }, dependent: :destroy
  has_many :items, through: :menu_category_items

  counter_culture :category, column_name: 'menus_count'
  counter_culture :menu, column_name: 'categories_count'

  acts_as_list scope: :menu

  accepts_nested_attributes_for :category, :menu_category_items

  delegate :prefix_id, :name, to: :category, prefix: true

  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def to_s
    category_name
  end
end
