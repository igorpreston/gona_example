class Webhooks::CloverController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_merchant!, only: [:create]

  def create
    payload = request.body.read
    event_data = JSON.parse(payload, symbolize_names: true)
    process_clover_event(event_data)

    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error "#{self.class.name}##{__method__} #{e.message}"
    head :bad_request
  end

  private

  def process_clover_event(event_data)
    ActiveRecord::Base.transaction do
      event_data[:merchants]&.each do |merchant_id, events|
        events.each do |event|
          webhook_event = create_webhook_event(:clover, event[:type], event.merge(merchant_id:))
          Clover::HandleEventJob.perform_later(webhook_event)
        end
      end
    end
  end

  def create_webhook_event(source, _data_type, data)
    Webhook.lock.create!(source:, data_type: data[:type], data:)
  end
end
