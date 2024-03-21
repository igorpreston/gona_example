class Feedback::ResponseCreatedHandler < EventHandler
  on Feedback::ResponseCreated

  def perform_async
    Feedback::ResponseCreatedNotification.with(feedback:, order_user:).deliver(order_user)
  end

  private

  def feedback
    @feedback ||= Feedback.find(event.id)
  end

  def order_user
    @order_user ||= feedback.order_user
  end
end
