class Stripe::PaymentIntentAmountCapturableUpdatedWebhook
  def call(event)
    stripe_payment_intent = event.data.object

    payment = Payment.find_by(stripe_payment_intent_id: stripe_payment_intent.id)

    return unless payment

    update_payment_capturable_amount(payment)
    transition_order_state(payment) if payment.paid? || payment.uncaptured?
  end

  private

  def update_payment_capturable_amount(payment)
    payment.state_machine.transition_to!(:uncaptured)
  end

  def transition_order_state(payment)
    state = payment.order&.dine_in? ? :completed : :submitted

    payment.order&.state_machine&.transition_to!(state)
  end
end
