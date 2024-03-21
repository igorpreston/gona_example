class Log::Order::InProgressHandler < EventHandler
  on Order::InProgress

  MESSAGE_KEY = Log::MESSAGE_KEYS[:order_in_progress]

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
