class Stripe::AccountUpdatedWebhook
  def call(event)
    stripe_account = event.data.object
    organization = Organization.find_by(stripe_account_id: stripe_account.id)

    return unless organization

    update_organization(organization, stripe_account)
  end

  private

  def update_organization(organization, stripe_account)
    organization.update!(
      name: stripe_account.business_profile.name,
      legal_name: stripe_account.company.name,
      email: stripe_account.email,
      charges_enabled: stripe_account.charges_enabled,
      payouts_enabled: stripe_account.payouts_enabled,
      details_submitted: stripe_account.details_submitted,
      address_attributes: address_attributes(stripe_account)
    )
  end

  def address_attributes(stripe_account)
    {
      line_one: stripe_account.company.address.line1,
      line_two: stripe_account.company.address.line2,
      city: stripe_account.company.address.city,
      state: stripe_account.company.address.state,
      zip: stripe_account.company.address.postal_code,
      country: stripe_account.company.address.country
    }
  end
end
