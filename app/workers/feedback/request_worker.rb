class Feedback::RequestWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 3

  def perform(order_id)
    order = Order.find(order_id)
    order.logs.create!(
      message_key: Log::MESSAGE_KEYS[:order_feedback_requested],
      scope: :internal,
      data: { user_id: order.user_id }
    )

    order.order_users.each do |order_user|
      recipient = order_user.user_id.present? ? order_user.user : order_user
      Order::FeedbackRequestNotification.with(order:, order_user:).deliver(recipient)
    end
  end
end
