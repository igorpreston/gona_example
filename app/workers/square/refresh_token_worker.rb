class Square::RefreshTokenWorker
  include Sidekiq::Worker

  sidekiq_options queue: :square, retry: 3

  def perform(integration_id)
    integration = Integration::Square.find(integration_id)
    response = obtain_square_token(integration)

    if response.success?
      update_integration(integration, response)
      schedule_next_refresh(integration)
    else
      handle_error(integration, response)
    end
  rescue StandardError => e
    handle_unexpected_error(integration, e)
  end

  private

  def obtain_square_token(integration)
    oauth_request_body = {
      client_id: ENV.fetch('SQUARE_APPLICATION_ID'),
      client_secret: ENV.fetch('SQUARE_APPLICATION_SECRET', nil),
      refresh_token: integration.refresh_token,
      grant_type: 'refresh_token'
    }

    oauth_api.obtain_token(body: oauth_request_body)
  end

  def oauth_api
    @oauth_api ||= ::Square::Client.new(
      environment: ENV.fetch('SQUARE_ENVIRONMENT', nil),
      access_token: ENV.fetch('SQUARE_APPLICATION_SECRET', nil),
      user_agent_detail: 'GONA'
    ).o_auth
  end

  def update_integration(integration, response)
    integration.update(
      access_token: response.body['access_token'],
      refresh_token: response.body['refresh_token'],
      expires_at: response.body['expires_at']&.to_datetime
    )

    integration.organization.update(
      square_id: response.body['merchant_id']
    )
  end

  def schedule_next_refresh(integration)
    self.class.schedule_next_refresh(integration)
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
    self.class.perform_in(7.days, integration.id)
  end
end
