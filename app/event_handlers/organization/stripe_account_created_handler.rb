class Organization::StripeAccountCreatedHandler < EventHandler
  on Organization::Created

  def perform
    ActiveRecord::Base.transaction do
      country = 'CA' # hardcoded for now; need to match with organization's country

      ::Stripe::Account.create(
        {
          country:,
          type: 'custom',
          email: organization.email,
          business_type: organization.business_category,
          capabilities: {
            card_payments: { requested: true },
            transfers: { requested: true }
          },
          business_profile: {
            name: organization.name,
            support_email: organization.email,
            url: Rails.application.routes.url_helpers.root_url(
              subdomain: :business, host: ENV.fetch('HOST')
            )
          },
          tos_acceptance: {
            service_agreement: country.in?(%w[CA US]) ? 'full' : 'recipient'
          }
        }
      ).tap do |account|
        organization.update(
          stripe_account_id: account.id
        )
      end
    end
  end

  private

  def organization
    @organization ||= Organization.lock.find(event.id)
  end
end
