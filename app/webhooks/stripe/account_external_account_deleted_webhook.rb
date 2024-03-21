class Stripe::AccountExternalAccountDeletedWebhook
  def call(event)
    stripe_account = event.data.object
    payment_method = PaymentMethod.find_by(processor_id: stripe_account.id)

    return unless payment_method

    payment_method.destroy
  end
end
