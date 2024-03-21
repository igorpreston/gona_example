class Log::Order::CancelledHandler < EventHandler
  on Order::Cancelled

  MESSAGE_KEY = Log::MESSAGE_KEYS[:order_cancelled]

  def perform_async
    ActiveRecord::Base.transaction do
      order.logs.create!(message_key: MESSAGE_KEY, scope: :external)
    end
  end

  private

  def order
    Order.lock.find(event.id)
  end
end
