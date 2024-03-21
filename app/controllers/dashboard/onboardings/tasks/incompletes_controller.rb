class Dashboard::Onboardings::Tasks::IncompletesController < ApplicationController
  def update
    if task.incomplete!
      redirect_to root_path, alert: 'Task incomplete!', turbolinks: false
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
