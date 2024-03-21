class Log::Order::CompletedHandler < EventHandler
  on Order::Completed

  MESSAGE_KEY = Log::MESSAGE_KEYS[:order_completed]

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
