class Organizations::StripeAccountLinksController < ApplicationController
  def show
    stripe_link = ::Stripe::AccountLink.create(
      account: organization.stripe_account_id,
      type: account_link_type,
      return_url: url,
      refresh_url: url,
      collect: 'eventually_due'
    )

    redirect_to stripe_link.url, allow_other_host: true
  end

  private

  def organization
    @organization ||= current_tenant
  end

  def url
    if organization.details_submitted
      edit_organization_url(subdomain: :business)
    else
      new_organization_url(subdomain: :business)
    end
  end

  def account_link_type
    if organization.details_submitted
      'account_update'
    else
      'account_onboarding'
    end
  end
end
