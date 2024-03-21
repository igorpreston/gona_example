# == Schema Information
#
# Table name: order_item_options
#
#  id                     :bigint           not null, primary key
#  currency               :string           default("CAD"), not null
#  price_cents            :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  option_id              :bigint           not null
#  order_item_modifier_id :bigint           not null
#
# Indexes
#
#  index_order_item_options_on_option_id               (option_id)
#  index_order_item_options_on_order_item_modifier_id  (order_item_modifier_id)
#  index_order_item_options_on_price_cents             (price_cents)
#
# Foreign Keys
#
#  fk_rails_...  (option_id => options.id)
#  fk_rails_...  (order_item_modifier_id => order_item_modifiers.id)
#
class OrderItemOption < ApplicationRecord
  belongs_to :order_item_modifier
  belongs_to :option

  before_validation :snapshot_price, on: :create

  monetize :price_cents, with_model_currency: :currency

  private

  def snapshot_price
    self.price_cents = option&.item&.price_cents || 0
    self.currency = option&.item&.currency || Rails.application.config.currency
  end
end
