class Dashboard::Onboardings::Tasks::CompletesController < ApplicationController
  def update
    if task.complete!
      redirect_to root_path, alert: 'Task completed!', turbolinks: false
    else
      redirect_to root_path, alert: 'Something went wrong', turbolinks: false
    end
  end

  private

  def task
    @task ||= Onboarding::Task.find(params[:id])
  end

  def onboarding
    @onboarding ||= task.onboarding
  end
end
