class Webhooks::StripeConnectController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_merchant!, only: [:create]

  def create
    service = identify_service(request)
    return head :bad_request unless service.present?

    send("handle_#{service}_event", request)
  end

  private

  def identify_service(request)
    return unless request.headers['Stripe-Signature'].present?

    'stripe'
  end

  def handle_stripe_event(request)
    payload = request.body.read
    signature = request.headers['Stripe-Signature']
    secret = ENV.fetch('STRIPE_CONNECT_WEBHOOK_SECRET', nil)

    event = ::Stripe::Webhook.construct_event(payload, signature, secret.to_s)

    ActiveRecord::Base.transaction do
      webhook_event = create_webhook_event(:stripe, event)
      Stripe::HandleEventJob.perform_later(webhook_event)
    end
  rescue ::Stripe::SignatureVerificationError => e
    raise e
  end

  def create_webhook_event(source, data)
    Webhook.lock.create!(source:, data_type: data[:type], data:)
  end
end
