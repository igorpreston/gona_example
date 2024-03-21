class Payment::CapturedHandler < EventHandler
  on Order::Ready, Order::Completed

  def perform_async
    order = Order.find(event.id)

    return unless order

    order.payments.where(status: :uncaptured)&.each(&:to_stripe_charge!)
  end
end
