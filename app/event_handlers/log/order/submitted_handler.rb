class Log::Order::SubmittedHandler < EventHandler
  on Order::Submitted

  MESSAGE_KEY = Log::MESSAGE_KEYS[:order_submitted]

  def perform_async
    ActiveRecord::Base.transaction do
      order.logs.create!(message_key: MESSAGE_KEY, scope: :external)
    end
  end

  private

  def order
    @order ||= Order.lock.find(event.id)
  end
end
