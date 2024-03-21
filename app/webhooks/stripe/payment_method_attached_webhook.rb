class Stripe::PaymentMethodAttachedWebhook
  def call(event)
    payment_method = event.data.object
    organization = Organization.find_by(stripe_customer_id: payment_method.customer)

    return unless organization

    organization.payment_methods.find_or_create_by(
      processor_id: payment_method.id
    ) do |pm|
      pm.source_type = payment_method.type
      pm.data = {
        stripe_account: payment_method.try(:customer),
        brand: payment_method.try(:card).try(:brand),
        last4: payment_method.try(:card).try(:last4),
        exp_month: payment_method.try(:card).try(:exp_month),
        exp_year: payment_method.try(:card).try(:exp_year),
        country: payment_method.try(:card).try(:country)&.upcase,
        funding: payment_method.try(:card).try(:funding)
      }
    end
  end
end
