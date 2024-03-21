# == Schema Information
#
# Table name: onboardings
#
#  id                    :bigint           not null, primary key
#  completed_at          :datetime
#  completed_tasks_count :integer          default(0), not null
#  status                :string           default("active"), not null
#  tasks_count           :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  organization_id       :bigint
#
# Indexes
#
#  index_onboardings_on_organization_id  (organization_id)
#
class Onboarding < ApplicationRecord
  has_prefix_id :onb, minimum_length: 12

  belongs_to :organization, optional: true

  after_commit :publish_onboarding_completed!, on: :update, if: -> { tasks.all?(&:completed?) and active? }

  enum :status, {
    active: 'active',
    completed: 'completed'
  }, _default: 'active'

  has_many :tasks, dependent: :destroy, class_name: Onboarding::Task.name.to_s

  validates :status, inclusion: { in: statuses.keys }

  def percentage
    return 0 if tasks_count.zero?

    (completed_tasks_count.to_f / tasks_count * 100).round
  end

  private

  def publish_onboarding_completed!
    publish_event Onboarding::Completed, id:
  end
end
