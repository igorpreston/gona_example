# == Schema Information
#
# Table name: menus
#
#  id                 :bigint           not null, primary key
#  active_items_count :integer          default(0), not null
#  categories_count   :integer          default(0), not null
#  description        :string
#  items_count        :integer          default(0), not null
#  locations_count    :integer          default(0), not null
#  name               :string           not null
#  published          :boolean          default(FALSE), not null
#  schedule           :jsonb
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  organization_id    :bigint           not null
#
# Indexes
#
#  index_menus_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Menu < ApplicationRecord
  include Scheduleable

  has_prefix_id :menu, minimum_length: 12

  after_create :publish_created!

  acts_as_tenant :organization, touch: true

  has_many :menu_categories, -> { order(position: :asc) }, dependent: :destroy
  has_many :categories, through: :menu_categories
  has_many :location_menus, dependent: :destroy
  has_many :locations, through: :location_menus

  scope :current, lambda {
    includes(
      menu_categories: [:category, { menu_category_items: { item: { photo_attachment: :blob } } }]
    ).where(published: true)
  }

  validates :name, presence: true

  def status
    published? ? 'published' : 'unpublished'
  end

  def active?
    published? && open?
  end

  private

  def publish_created!
    publish_event Menu::Created, id:
  end
end
