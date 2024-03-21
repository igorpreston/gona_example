# == Schema Information
#
# Table name: order_item_modifiers
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  modifier_id   :bigint           not null
#  order_item_id :bigint           not null
#
# Indexes
#
#  index_order_item_modifiers_on_modifier_id    (modifier_id)
#  index_order_item_modifiers_on_order_item_id  (order_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (modifier_id => modifiers.id)
#  fk_rails_...  (order_item_id => order_items.id)
#
class OrderItemModifier < ApplicationRecord
  belongs_to :order_item
  belongs_to :modifier

  has_many :order_item_options, dependent: :destroy
  has_many :options, through: :order_item_options

  counter_culture :order_item, column_name: 'modifiers_count'
end
