# == Schema Information
#
# Table name: payment_transitions
#
#  id          :bigint           not null, primary key
#  metadata    :jsonb
#  most_recent :boolean          not null
#  sort_key    :integer          not null
#  to_state    :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  payment_id  :integer          not null
#
# Indexes
#
#  index_payment_transitions_parent_most_recent  (payment_id,most_recent) UNIQUE WHERE most_recent
#  index_payment_transitions_parent_sort         (payment_id,sort_key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (payment_id => payments.id)
#
class Payment::Transition < ApplicationRecord
  validates :to_state, inclusion: { in: Payment::StateMachine.states }

  belongs_to :payment, inverse_of: :transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = payment.transitions.order(:sort_key).last

    return if last_transition.blank?

    last_transition.update!(most_recent: true)
  end
end
