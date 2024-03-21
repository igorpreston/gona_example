class Square::OrderCreatedWebhook
  include SquareClient

  def call(event)
    square_object = event.data
    location = find_location(square_object.dig('data', 'object', 'order_created', 'location_id'))

    nil unless location

    # square_order = fetch_square_order(square_object.dig('data', 'object', 'order_created', 'order_id'))

    # byebug
  end

  private

  def fetch_square_order(_integration, _order_id)
  rescue StandardError => e
    Rails.logger.error("[#{self.class.name}##{__method__}]: #{e.message}")
    nil
  end

  def find_location(square_id)
    @location ||= Location.find_by(square_id:)
  end
end
