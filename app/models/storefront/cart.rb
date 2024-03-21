# == Schema Information
#
# Table name: carts
#
#  id                 :bigint           not null, primary key
#  draft_orders_count :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#
class Storefront::Cart < ApplicationRecord
  has_prefix_id :cart, minimum_length: 18

  belongs_to :user, optional: true

  has_many :orders, dependent: :nullify

  def subtotal
    orders.sum(&:subtotal)
  end

  def tax
    orders.includes(:location).sum(&:tax)
  end

  def amount
    orders.sum(&:amount)
  end
end
