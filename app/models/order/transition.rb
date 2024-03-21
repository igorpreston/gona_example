# == Schema Information
#
# Table name: order_transitions
#
#  id          :bigint           not null, primary key
#  metadata    :jsonb
#  most_recent :boolean          not null
#  sort_key    :integer          not null
#  to_state    :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  order_id    :integer          not null
#
# Indexes
#
#  index_order_transitions_parent_most_recent  (order_id,most_recent) UNIQUE WHERE most_recent
#  index_order_transitions_parent_sort         (order_id,sort_key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
class Order::Transition < ApplicationRecord
  validates :to_state, inclusion: { in: Order::StateMachine.states }

  belongs_to :order, inverse_of: :transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = order.transitions.order(:sort_key).last

    return if last_transition.blank?

    last_transition.update!(most_recent: true)
  end
end
