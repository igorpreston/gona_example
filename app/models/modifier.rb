# == Schema Information
#
# Table name: modifiers
#
#  id                :bigint           not null, primary key
#  items_count       :integer          default(0)
#  max_option_select :integer          default(1)
#  max_select        :integer          default(1)
#  min_select        :integer          default(0)
#  name              :string           not null
#  options_count     :integer          default(0)
#  required          :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  organization_id   :bigint           not null
#  square_id         :string
#
# Indexes
#
#  index_modifiers_on_organization_id  (organization_id)
#  index_modifiers_on_square_id        (square_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Modifier < ApplicationRecord
  MIN_SELECT = 0
  MIN_SELECT_IF_REQUIRED = 1

  has_prefix_id :mod, minimum_length: 18

  acts_as_tenant :organization

  has_many :item_modifiers, dependent: :destroy
  has_many :items, through: :item_modifiers
  has_many :options, dependent: :destroy

  has_many :order_item_modifiers
  has_many :order_items, through: :order_item_modifiers

  validates :name, presence: true
  validates :min_select, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: MIN_SELECT
  }, unless: -> { required? }
  validates :min_select, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: MIN_SELECT_IF_REQUIRED
  }, if: -> { required? }
  validates :max_select, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: :min_select
  }

  accepts_nested_attributes_for :options, reject_if: :invalid_option?, allow_destroy: true

  def multi_select?
    max_select > 1
  end

  def single_select?
    max_select == 1
  end

  private

  def invalid_option?(attributes)
    attributes['item_attributes']['name'].blank?
  end
end
