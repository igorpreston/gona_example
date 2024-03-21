class Onboarding::Task::OrganizationCompletedHandler < EventHandler
  on Organization::OnboardingTaskCompleted

  def perform
    ActiveRecord::Base.transaction do
      check_for_touch(organization)
    end
  end

  private

  def organization
    @organization ||= Organization.lock.find(event.id)
  end

  def check_for_touch(organization)
    task_completed?(:complete_stripe_onboarding) if organization.details_submitted?
    task_completed?(:create_integration) if integration_created?(organization)
    task_completed?(:create_location) if location_created?(organization)
    task_completed?(:create_subscription) if subscription_created?(organization)
    task_completed?(:create_product) if item_created?(organization)
    task_completed?(:create_category) if category_created?(organization)
    task_completed?(:create_menu) if menu_created?(organization)
  end

  def item_created?(organization)
    organization.items.exists?
  end

  def category_created?(organization)
    organization.categories.exists?
  end

  def menu_created?(organization)
    organization.menus.exists?
  end

  def integration_created?(organization)
    organization.integrations.exists?
  end

  def location_created?(organization)
    organization.locations.exists?
  end

  def subscription_created?(organization)
    organization.subscriptions.exists?
  end

  def task_completed?(template)
    task = organization.onboarding.tasks.find_by(template:)
    task&.complete! unless task&.completed?
  end
end
