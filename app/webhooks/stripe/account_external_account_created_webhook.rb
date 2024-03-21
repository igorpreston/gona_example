class Stripe::AccountExternalAccountCreatedWebhook
  def call(event)
    stripe_account = event.data.object
    organization = Organization.find_by(stripe_account_id: stripe_account.try(:account))

    return unless organization

    create_payment_method(organization, stripe_account)
  end

  private

  def create_payment_method(organization, stripe_account)
    organization.payment_methods.find_or_create_by(
      processor_id: stripe_account.id
    ) do |pm|
      pm.source_type = stripe_account.object
      pm.data = stripe_account.to_hash
    end
  end
end
