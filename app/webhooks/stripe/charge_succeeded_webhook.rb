class Stripe::ChargeSucceededWebhook
  def call(event)
    stripe_charge = event.data.object
    payment = Payment.find_by(stripe_payment_intent_id: stripe_charge.payment_intent)

    return unless payment

    payment.update(latest_charge_data: stripe_charge, paid_at: DateTime.now)
  end
end
