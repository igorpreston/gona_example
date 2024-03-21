# == Schema Information
#
# Table name: categories
#
#  id              :bigint           not null, primary key
#  health          :jsonb            not null
#  items_count     :integer          default(0)
#  menus_count     :integer          default(0)
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  square_id       :string
#
# Indexes
#
#  index_categories_on_organization_id  (organization_id)
#  index_categories_on_square_id        (square_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Category < ApplicationRecord
  has_prefix_id :cat, minimum_length: 18

  acts_as_tenant :organization, touch: true

  has_many :menu_categories, dependent: :destroy
  has_many :menus, through: :menu_categories
  has_many :category_items, dependent: :destroy
  has_many :items, through: :category_items

  validates :name, presence: true

  def to_s
    name
  end
end
