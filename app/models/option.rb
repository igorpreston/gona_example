# == Schema Information
#
# Table name: options
#
#  id              :bigint           not null, primary key
#  position        :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  item_id         :bigint
#  modifier_id     :bigint
#  option_id       :bigint
#  organization_id :bigint           not null
#
# Indexes
#
#  index_options_on_item_id          (item_id)
#  index_options_on_modifier_id      (modifier_id)
#  index_options_on_option_id        (option_id)
#  index_options_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Option < ApplicationRecord
  has_prefix_id :opt, minimum_length: 18

  acts_as_list scope: :modifier
  acts_as_tenant :organization

  belongs_to :item, optional: true, dependent: :destroy
  belongs_to :modifier, optional: true
  belongs_to :option, optional: true

  has_many :options, dependent: :destroy

  has_many :order_item_options
  has_many :order_item_modifiers, through: :order_item_options

  counter_culture :modifier, column_name: :options_count

  delegate :name, :price_cents, :price_formatted, to: :item, prefix: true

  accepts_nested_attributes_for :item, reject_if: :all_blank, allow_destroy: true

  def item_name_with_price
    "#{item_name} - #{item_price_formatted}"
  end

  def free?
    item_price_cents.zero?
  end
end
