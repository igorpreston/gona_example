class Square::LocationCreatedOrUpdatedWebhook
  include SquareClient

  def call(event)
    square_object = event.data
    organization = find_organization(square_object['merchant_id'])
    integration = find_square_integration(organization)

    return unless organization && integration

    square_location_object = fetch_square_location(integration, square_object['location_id'])

    Integration::Square::SyncLocation.new(square_location_object:).perform
  end

  private

  def fetch_square_location(integration, location_id)
    square_client(integration).locations.retrieve_location(location_id:).data.location
  rescue StandardError => e
    Rails.logger.error("[#{self.class.name}##{__method__}]: #{e.message}")
    nil
  end

  def find_organization(merchant_id)
    return unless merchant_id.present?

    Organization.find_by(square_id: merchant_id)
  end

  def find_square_integration(organization)
    organization&.integrations&.find_by(type: Integration::Square.name)
  end
end
