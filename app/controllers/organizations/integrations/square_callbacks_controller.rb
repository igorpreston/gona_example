class Organizations::Integrations::SquareCallbacksController < ApplicationController
  before_action :authorize_square_integration, only: [:show]

  def show
    create_or_update_square_integration
    flash_message = @integration ? 'Square integration has been successfully authorized' : 'Square integration authorization has failed'

    redirect_to organization_integrations_path, notice: flash_message
  end

  private

  def authorize_square_integration
    authorization_code = params['code']
    return redirect_and_set_alert('Square integration authorization has failed') if authorization_code.blank?

    @response = obtain_square_token(authorization_code)
    redirect_and_set_alert('Square integration authorization has failed') unless @response.success?
  end

  def obtain_square_token(authorization_code)
    oauth_request_body = {
      client_id: ENV.fetch('SQUARE_APPLICATION_ID', nil),
      client_secret: ENV.fetch('SQUARE_APPLICATION_SECRET', nil),
      code: authorization_code,
      grant_type: 'authorization_code',
      short_lived: false
    }

    oauth_api.obtain_token(body: oauth_request_body)
  end

  def create_or_update_square_integration
    @integration = current_tenant.integrations.find_or_initialize_by(
      type: Integration::Square.name,
      app: App.find_by(template: App::TEMPLATES.key(Integration::Square))
    )

    @integration.update(
      access_token: @response.body['access_token'],
      refresh_token: @response.body['refresh_token'],
      expires_at: @response.body['expires_at']&.to_datetime
    )

    @integration.organization.update(
      square_id: @response.body['merchant_id']
    )
  end

  def redirect_and_set_alert(message)
    flash[:alert] = message
    redirect_to organization_integrations_path
  end

  def oauth_api
    @oauth_api ||= ::Square::Client.new(
      environment: ENV.fetch('SQUARE_ENVIRONMENT', nil),
      access_token: ENV.fetch('SQUARE_APPLICATION_SECRET', nil),
      user_agent_detail: 'GONA'
    ).o_auth
  end
end
