class Webhooks::SquareController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_merchant!, only: [:create]

  def create
    signature = request.env['HTTP_X_SQUARE_HMACSHA256_SIGNATURE']
    body = request.body.read

    if from_square?(signature, body)
      event_data = JSON.parse(body, symbolize_names: true)
      process_square_event(event_data)
    else
      head :bad_request and return
    end

    head :ok
  end

  private

  def from_square?(signature, body)
    notification_url = request.original_url
    data = notification_url + body

    digest = OpenSSL::Digest.new('sha256')
    signature_key = ENV['SQUARE_WEBHOOK_SECRET']
    hmac = OpenSSL::HMAC.digest(digest, signature_key, data)

    signature == Base64.strict_encode64(hmac)
  end

  def process_square_event(event_data)
    webhook_event = create_webhook_event(:square, event_data[:type], event_data)
    Square::HandleEventJob.perform_later(webhook_event)
  end

  def create_webhook_event(source, _data_type, data)
    Webhook.lock.create!(source:, data_type: data[:type], data:)
  end
end
