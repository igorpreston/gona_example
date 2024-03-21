class Integration::Square::LocationsSyncedHandler < EventHandler
  include SquareClient

  on Integration::Square::Created

  def perform_async
    square_client = square_client(integration)
    fetch_and_process_locations(square_client)
  end

  private

  def fetch_and_process_locations(square_client, cursor: nil)
    response = square_client.locations.list_locations(cursor:)

    process_locations(response.data.locations)

    fetch_and_process_locations(square_client, cursor: response.cursor) if response.cursor
  end

  def process_locations(locations)
    locations.each do |square_location_object|
      Integration::Square::SyncLocation.new(square_location_object:).perform
    end
  end

  def integration
    @integration ||= Integration::Square.find(event.id)
  end
end
