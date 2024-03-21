class Subscriptions::CheckoutsController < ApplicationController
  before_action :authenticate_merchant!, only: [:create]

  def create
    stripe_price_id = params[:price_id]

    session = ::Stripe::Checkout::Session.create(
      customer: current_tenant.stripe_customer_id,
      client_reference_id: current_tenant.prefix_id,
      success_url: root_url(subdomain: :business) + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: root_url(subdomain: :business),
      payment_method_types: %w[card],
      mode: 'subscription',
      line_items: [{
        price: stripe_price_id,
        quantity: 1
      }]
    )

    redirect_to session.url, allow_other_host: true
  end
end
