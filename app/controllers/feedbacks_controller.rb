class FeedbacksController < ApplicationController
  def index
    render locals: { feedbacks: }
  end

  def show
    render locals: { feedback: }
  end

  def update
    if feedback.update(feedback_params)
      redirect_to feedbacks_path, notice: 'Feedback was successfully updated.'
    else
      redirect_to feedbacks_path, alert: 'Feedback could not be updated.'
    end
  end

  private

  def feedbacks
    @pagy, @feedbacks = pagy(
      current_tenant.feedbacks.includes(
        user: { avatar_attachment: :blob }
      ).order(created_at: :desc), items: 20
    )
  end

  def feedback
    @feedback ||= current_tenant.feedbacks.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:response)
  end
end
