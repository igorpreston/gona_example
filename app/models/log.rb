# == Schema Information
#
# Table name: logs
#
#  id          :bigint           not null, primary key
#  data        :jsonb            not null
#  message_key :string           not null
#  scope       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  order_id    :bigint
#  qr_code_id  :bigint
#
# Indexes
#
#  index_logs_on_order_id    (order_id)
#  index_logs_on_qr_code_id  (qr_code_id)
#
class Log < ApplicationRecord
  has_prefix_id :log, minimum_length: 20

  MESSAGE_KEYS = {
    order_created: 'order.created',
    order_submitted: 'order.submitted',
    order_in_progress: 'order.in_progress',
    order_ready_for_take_out: 'order.ready_for_take_out',
    order_ready_for_delivery: 'order.ready_for_delivery',
    order_ready_for_dine_in: 'order.ready_for_dine_in',
    order_completed: 'order.completed',
    order_cancelled: 'order.cancelled',
    order_feedback_requested: 'order.feedback_requested',
    qr_code_scanned: 'qr_code.scanned'
  }.freeze

  belongs_to :qr_code, optional: true
  # belongs_to :order, optional: true

  # internal - logs that should be visible to the organization
  # external - logs that should be visible to the customer and the organization
  enum scope: {
    internal: 'internal',
    external: 'external'
  }, _default: 'internal'

  validates :message_key, presence: true, inclusion: { in: MESSAGE_KEYS.values }
  validates :scope, presence: true, inclusion: { in: scopes.keys }
end
