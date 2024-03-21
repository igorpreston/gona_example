# == Schema Information
#
# Table name: order_users
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  paying_for :integer
#  phone      :string
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  user_id    :bigint
#
# Indexes
#
#  index_order_users_on_order_id  (order_id)
#  index_order_users_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (user_id => merchants.id)
#
class OrderUser < ApplicationRecord
  include Receipt

  has_prefix_id :ou, minimum_length: 18

  acts_as_list scope: :order

  belongs_to :order
  belongs_to :user, optional: true

  has_one :payment, dependent: :destroy
  has_one :feedback, dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy
end
