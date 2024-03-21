# == Schema Information
#
# Table name: order_items
#
#  id              :bigint           not null, primary key
#  currency        :string           default("CAD"), not null
#  modifiers_count :integer          default(0), not null
#  price_cents     :integer          default(0), not null
#  quantity        :integer          default(1), not null
#  status          :string           default("added"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  item_id         :bigint           not null
#  order_id        :bigint           not null
#
# Indexes
#
#  index_order_items_on_item_id   (item_id)
#  index_order_items_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (order_id => orders.id)
#
class OrderItem < ApplicationRecord
  QUANTITY_MIN = 1

  has_prefix_id :oi, minimum_length: 18

  monetize :price_cents, with_model_currency: :currency, allow_nil: false

  belongs_to :order
  belongs_to :item

  has_one :note, as: :notable, dependent: :destroy

  has_many :order_item_modifiers, dependent: :destroy
  has_many :modifiers, through: :order_item_modifiers
  has_many :applied_options, through: :order_item_modifiers, source: :options

  counter_culture :order, column_name: 'items_count', delta_magnitude: ->(model) { model.quantity }
  counter_culture :order, column_name: ->(model) { model.added? ? 'added_items_count' : nil }

  enum status: {
    added: 'added',
    unpaid: 'unpaid',
    paid: 'paid',
    cancelled: 'cancelled',
    refunded: 'refunded'
  }, _default: 'added'

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: QUANTITY_MIN }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validate :validate_number_of_applied_options

  accepts_nested_attributes_for :note, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :order_item_modifiers, allow_destroy: true

  def amount_cents
    price_cents * quantity
  end

  def formatted_applied_options
    applied_options.map do |applied_option|
      [
        applied_option.item_name,
        applied_option.free? ? nil : "(#{applied_option.item_price_formatted})"
      ].compact.join(' ')
    end.join(', ')
  end

  def total_with_options_cents
    order_item_modifiers.joins(:order_item_options).sum('order_item_options.price_cents') + amount_cents
  end

  def validate_number_of_applied_options
    applied_options.group_by(&:modifier).each do |modifier, options|
      errors.add(:applied_options, "minimum #{modifier.min_select} required") if options.size < modifier.min_select
      errors.add(:applied_options, "maximum #{modifier.max_select} allowed") if options.size > modifier.max_select
    end
  end
end
