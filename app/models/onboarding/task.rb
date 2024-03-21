# == Schema Information
#
# Table name: onboarding_tasks
#
#  id            :bigint           not null, primary key
#  category      :string           not null
#  completed_at  :datetime
#  template      :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  onboarding_id :bigint           not null
#
# Indexes
#
#  index_onboarding_tasks_on_onboarding_id  (onboarding_id)
#
# Foreign Keys
#
#  fk_rails_...  (onboarding_id => onboardings.id)
#
class Onboarding::Task < ApplicationRecord
  has_prefix_id :ot, minimum_length: 18

  counter_culture :onboarding, column_name: 'tasks_count'
  counter_culture :onboarding, column_name: proc { |model|
    model.completed? ? 'completed_tasks_count' : nil
  }

  enum :template, {
    complete_stripe_onboarding: 'complete_stripe_onboarding',
    create_integration: 'create_integration',
    create_location: 'create_location',
    create_product: 'create_product',
    create_category: 'create_category',
    create_menu: 'create_menu'
  }

  enum category: {
    organization_settings: 'organization_settings',
    organization_inventory: 'organization_inventory'
  }

  belongs_to :onboarding, touch: true

  validates :template, presence: true, uniqueness: { scope: :onboarding_id }, inclusion: { in: templates.keys }

  def completed?
    completed_at?
  end

  def complete!
    update(completed_at: DateTime.current)
  end

  def incomplete!
    update(completed_at: nil)
  end
end
