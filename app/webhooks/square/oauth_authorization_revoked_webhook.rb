class Square::OauthAuthorizationRevokedWebhook
  def call(event)
    square_object = event.data
    organization = Organization.find_by(square_id: square_object['merchant_id'])

    return unless organization

    integration = organization.integrations.find_by(type: Integration::Square.name)
    integration&.destroy
  rescue StandardError => e
    Rails.logger.error("Square::OauthAuthorizationRevokedWebhook: #{e.message}")
  end
end
