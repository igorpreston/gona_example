class Stripe::PaymentIntentSucceededWebhook
  def call(event)
    stripe_payment_intent = event.data.object
    payment = Payment.find_by(stripe_payment_intent_id: stripe_payment_intent.id)

    return unless payment

    payment.state_machine.transition_to!(:paid)
  end
end
