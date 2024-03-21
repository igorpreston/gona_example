class Stripe::CustomerUpdatedWebhook
  def call(event)
    stripe_customer = event.data.object
    organization = Organization.find_by(stripe_customer_id: stripe_customer.id)

    return unless organization

    organization.update(
      email: stripe_customer.email,
      legal_name: stripe_customer.name,
      phone: stripe_customer.phone
    )
  end
end
