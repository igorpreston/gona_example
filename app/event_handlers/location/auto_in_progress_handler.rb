class Location::AutoInProgressHandler < EventHandler
  on Order::Submitted

  def perform_async
    ActiveRecord::Base.transaction do
      order.state_machine.transition_to!(:in_progress) if order.location.auto_accept_order?
    end
  end

  private

  def order
    @order ||= Order.lock.find(event.id)
  end
end
