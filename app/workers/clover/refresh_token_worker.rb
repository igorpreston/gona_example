class Clover::RefreshTokenWorker
  include Sidekiq::Worker

  sidekiq_options queue: :clover, retry: 3

  def perform(integration_id)
    integration = Integration::Clover.find(integration_id)
    response = obtain_clover_token(integration)

    if response['access_token'].present?
      update_integration(integration, response)
      schedule_next_refresh(integration)
    else
      handle_error(integration, response)
    end
  rescue StandardError => e
    handle_unexpected_error(integration, e)
  end

  private

  def obtain_clover_token(integration)
    auth_url = Rails.env.production? ? Integration::Clover::AUTH_REFRESH_URL_PRODUCTION_NA : Integration::Clover::AUTH_REFRESH_URL_SANDBOX

    uri = URI.parse(auth_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'

    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = {
      client_id: ENV['CLOVER_APPLICATION_ID'],
      refresh_token: integration.refresh_token
    }.to_json

    response = http.request(request)
    JSON.parse(response.body)
  rescue StandardError, JSON::ParserError => e
    Rails.logger.error "#{self.class.name}##{__method__} error: #{e.message}"
    {}
  end

  def update_integration(integration, response)
    integration.update(
      configs: {
        access_token: response['access_token'],
        access_token_expiration: Time.at(response['access_token_expiration']&.to_i),
        refresh_token: response['refresh_token'],
        refresh_token_expiration: Time.at(response['refresh_token_expiration']&.to_i)
      }
    )
  end

  def handle_error(integration, response)
    Rails.logger.error(
      "[#{self.class.name}] failed to refresh token for integration #{integration.id} with response: #{response.body}"
    )
  end

  def handle_unexpected_error(integration, error)
    Rails.logger.error(
      "[#{self.class.name}] encountered an unexpected error for integration #{integration.id}: #{error.message}"
    )
  end

  def schedule_next_refresh(integration)
    self.class.perform_in(integration.access_token_expiration, integration.id)
  end
end
