class Stripe::CustomerCreatedWebhook
  def call(event)
    stripe_customer = event.data.object
    organization = Organization.find_by(stripe_customer_id: stripe_customer.id)

    return if organization

    Organization.create(
      name: stripe_customer.name,
      email: stripe_customer.email,
      phone: stripe_customer.phone,
      address_attributes: {
        line_one: stripe_customer.address.line1,
        line_two: stripe_customer.address.line2,
        city: stripe_customer.address.city,
        state: stripe_customer.address.state,
        zip: stripe_customer.address.postal_code,
        country: stripe_customer.address.country&.upcase
      }
    )
  end
end
