class Feedback::ReceivedHandler < EventHandler
  on Feedback::Created

  def perform_async
    Organization::FeedbackReceivedNotification.with(feedback:).deliver(feedback.organization)
  end

  private

  def feedback
    @feedback ||= Feedback.find(event.id)
  end
end
