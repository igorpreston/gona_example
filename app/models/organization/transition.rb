# == Schema Information
#
# Table name: organization_transitions
#
#  id              :bigint           not null, primary key
#  metadata        :jsonb
#  most_recent     :boolean          not null
#  sort_key        :integer          not null
#  to_state        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer          not null
#
# Indexes
#
#  index_organization_transitions_parent_most_recent  (organization_id,most_recent) UNIQUE WHERE most_recent
#  index_organization_transitions_parent_sort         (organization_id,sort_key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Organization::Transition < ApplicationRecord
  validates :to_state, inclusion: { in: Organization::StateMachine.states }

  belongs_to :organization, inverse_of: :transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = organization.transitions.order(:sort_key).last

    return if last_transition.blank?

    last_transition.update!(most_recent: true)
  end
end
