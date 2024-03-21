class Organizations::Integrations::CloverCallbacksController < ApplicationController
  def show
    if params[:code].present?
      response = exchange_token_for_access_token(params[:code])

      if response['access_token']
        create_clover_integration(response, params)
        redirect_to organization_integrations_path, notice: 'Clover integration has been successfully authorized'
      else
        redirect_to organization_integrations_path, alert: 'Failed to authorize Clover integration'
      end
    else
      redirect_to organization_integrations_path, alert: 'Authorization code not provided'
    end
  end

  private

  def exchange_token_for_access_token(code)
    auth_url = Rails.env.production? ? Integration::Clover::AUTH_URL_PRODUCTION_NA : Integration::Clover::AUTH_URL_SANDBOX

    uri = URI.parse(auth_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'

    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = {
      client_id: ENV['CLOVER_APPLICATION_ID'],
      client_secret: ENV['CLOVER_APPLICATION_SECRET'],
      code:,
      grant_type: 'authorization_code'
    }.to_json

    response = http.request(request)
    JSON.parse(response.body)
  rescue StandardError, JSON::ParserError => e
    Rails.logger.error "#{self.class.name}##{__method__} error: #{e.message}"
    {}
  end

  def create_clover_integration(response, params)
    integration = current_tenant.integrations.find_or_initialize_by(
      app: App.find_by(template: App::TEMPLATES.key(Integration::Clover)),
      type: Integration::Clover.name
    )

    integration.update(
      configs: {
        access_token: response['access_token'],
        access_token_expiration: Time.at(response['access_token_expiration'].to_i),
        refresh_token: response['refresh_token'],
        refresh_token_expiration: Time.at(response['refresh_token_expiration'].to_i)
      }
    )

    integration.organization.update(clover_id: params['merchant_id']) if params['merchant_id'].present?
  end
end
