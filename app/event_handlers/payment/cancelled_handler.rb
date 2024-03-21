class Payment::CancelledHandler < EventHandler
  on Order::Cancelled

  def perform_async
    Order.find(event.id).payments.where(status: :uncaptured).each do |payment|
      cancel_payment(payment) if payment.stripe_payment_intent_id
    end
  end

  private

  def cancel_payment(payment)
    Payment::CancelStripePaymentIntent.new(payment_id: payment.id).perform
  end
end
