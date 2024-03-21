class Order::SubmittedHandler < EventHandler
  on Order::Submitted

  def perform
    ActiveRecord::Base.transaction do
      order.update!(
        preparation_time_seconds: order.location.expected_preparation_time_seconds || 900 # 15 minutes
      )
    end
  end

  private

  def order
    @order ||= Order.lock.find(event.id)
  end
end
