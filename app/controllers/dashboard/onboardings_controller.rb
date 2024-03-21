class Dashboard::OnboardingsController < ApplicationController
  def show
    render layout: false, locals: {
      onboarding:,
      unique_task_categories:,
      tasks_by_categories:
    }
  end

  private

  def onboarding
    @onboarding ||= current_tenant.onboarding
  end

  def unique_task_categories
    @unique_task_categories ||= onboarding.tasks.distinct.order(category: :desc).pluck(:category)
  end

  def tasks_by_categories
    @tasks_by_categories ||= onboarding.tasks.order(created_at: :asc).group_by(&:category)
  end
end
