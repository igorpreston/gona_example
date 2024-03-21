class Stripe::PaymentMethodUpdatedWebhook
  def call(event)
    stripe_payment_method = event.data.object
    payment_method = PaymentMethod.find_by(processor_id: stripe_payment_method.id)

    return unless payment_method

    payment_method.update!(
      data: stripe_payment_method,
      default: stripe_payment_method.try(:default_for_currency)
    )
  end
end
