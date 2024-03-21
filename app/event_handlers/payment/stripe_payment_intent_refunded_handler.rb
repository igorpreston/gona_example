class Payment::StripePaymentIntentRefundedHandler < EventHandler
  on Payment::Refunded

  def perform
    Payment::RefundStripePaymentIntent.new(payment_id: event.id).perform
  end
end
