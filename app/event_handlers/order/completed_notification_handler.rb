class Order::CompletedNotificationHandler < EventHandler
  on Order::Completed

  def perform
    ActiveRecord::Base.transaction do
      order_users.each do |order_user|
        recipient = order_user.user_id.present? ? order_user.user : order_user
        Order::CompletedNotification.with(order:, order_user:).deliver(recipient)
      end
    end
  end

  private

  def order
    @order ||= Order.lock.find(event.id)
  end

  def order_users
    @order_users ||= order.order_users
  end
end