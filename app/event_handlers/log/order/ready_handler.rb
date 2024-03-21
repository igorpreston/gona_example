class Log::Order::ReadyHandler < EventHandler
  on Order::Ready

  KEY = {
    Order.preferences[:take_out] => :order_ready_for_take_out,
    Order.preferences[:delivery] => :order_ready_for_delivery,
    Order.preferences[:dine_in] => :order_ready_for_dine_in
  }.freeze

  def perform_async
    ActiveRecord::Base.transaction do
      order.logs.create!(message_key: Log::MESSAGE_KEYS[KEY[order.preference]], scope: :external)
    end
  end

  private

  def order
    Order.lock.find(event.id)
  end
end
