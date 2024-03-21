class Stripe::CustomerDeletedWebhook
  def call(event)
    stripe_customer = event.data.object
    organization = Organization.find_by(stripe_customer_id: stripe_customer.id)

    return unless organization

    organization.update(
      stripe_customer_id: nil,
      status: :disabled
    )
  end
end
