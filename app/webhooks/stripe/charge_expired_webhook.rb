class Stripe::ChargeExpiredWebhook
  def call(event)
    stripe_charge = event.data.object
    payment = Payment.find_by(stripe_payment_intent_id: stripe_charge.payment_intent)

    return unless payment

    payment.update(latest_charge_data: stripe_charge, cancelled_at: DateTime.now)
  end
end
