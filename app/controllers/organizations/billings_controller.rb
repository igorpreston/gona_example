class Organizations::BillingsController < ApplicationController
  def show
    session = ::Stripe::BillingPortal::Session.create(
      {
        customer: organization.stripe_customer_id,
        return_url: edit_organization_url(subdomain: :business)
      }
    )

    redirect_to session.url, allow_other_host: true
  end

  private

  def organization
    @organization ||= current_tenant
  end
end
