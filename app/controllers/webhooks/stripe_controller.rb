class Webhooks::StripeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_merchant!, only: [:create]

  def create
    payload = request.body.read
    signature = request.headers['Stripe-Signature']
    secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = ::Stripe::Webhook.construct_event(payload, signature, secret)
      process_stripe_event(event)
    rescue ::Stripe::SignatureVerificationError => e
      Rails.logger.error "#{self.class.name}##{__method__} #{e.message}"
      head :bad_request and return
    rescue JSON::ParserError => e
      Rails.logger.error "#{self.class.name}##{__method__} #{e.message}"
      head :bad_request and return
    end

    head :ok
  end

  private

  def process_stripe_event(event)
    webhook_event = create_webhook_event(:stripe, event.type, event)
    Stripe::HandleEventJob.perform_later(webhook_event)
  end

  def create_webhook_event(source, _data_type, data)
    Webhook.lock.create!(source:, data_type: data[:type], data:)
  end
end
