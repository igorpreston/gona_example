# == Schema Information
#
# Table name: items
#
#  id              :bigint           not null, primary key
#  currency        :string           default("CAD"), not null
#  deleted_at      :datetime
#  description     :text
#  internal_tags   :string           default([]), is an Array
#  menus_count     :integer          default(0), not null
#  metadata        :jsonb            not null
#  modifiers_count :integer          default(0), not null
#  name            :string           not null
#  price_cents     :integer          default(0)
#  sold_out        :boolean          default(FALSE), not null
#  source          :string           not null
#  unit            :string           default("ea"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  square_id       :string
#
# Indexes
#
#  index_items_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Item < ApplicationRecord
  PRICE_MIN = 0

  has_prefix_id :itm, minimum_length: 18

  after_commit :publish_created!, on: :create, if: -> { catalog? }

  monetize :price_cents, with_model_currency: :currency, allow_nil: true

  acts_as_paranoid

  acts_as_tenant :organization, touch: true

  has_many :category_items, dependent: :destroy
  has_many :categories, through: :category_items
  has_many :menu_category_items, dependent: :destroy
  has_many :item_modifiers, dependent: :destroy
  has_many :modifiers, through: :item_modifiers

  has_one_attached :photo, dependent: :destroy

  enum source: {
    catalog: 'catalog',
    modifier: 'modifier'
  }, _default: 'modifier' # we want to default to modifier

  enum unit: {
    ea: 'ea'
  }, _default: 'ea'

  attribute :metadata, Item::Metadata.to_type

  validates :name, presence: true
  validates :price, allow_nil: true, numericality: { greater_than_or_equal_to: PRICE_MIN }
  validates :currency, presence: true, inclusion: { in: Rails.application.config.currencies }
  validates :source, presence: true, inclusion: { in: sources.keys }
  validates :unit, presence: true, inclusion: { in: units.keys }

  def price_formatted
    price&.format
  end

  def price_humanized
    price.to_s
  end

  def status
    menus_count.positive? ? 'active' : 'not_active'
  end

  private

  def publish_created!
    publish_event Item::Created, id:
  end
end
