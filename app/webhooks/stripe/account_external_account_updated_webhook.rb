class Stripe::AccountExternalAccountUpdatedWebhook
  def call(event)
    stripe_account = event.data.object
    payment_method = PaymentMethod.find_by(processor_id: stripe_account.id)

    return unless payment_method

    payment_method.update!(data: stripe_account.to_hash, default: stripe_account.try(:default_for_currency))
  end
end
