class Log::Order::CreatedHandler < EventHandler
  on Order::Created

  MESSAGE_KEY = Log::MESSAGE_KEYS[:order_created]

  def perform_async
    ActiveRecord::Base.transaction do
      order.logs.create!(message_key: MESSAGE_KEY, scope: :internal)
    end
  end

  private

  def order
    Order.lock.find(event.id)
  end
end
