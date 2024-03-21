class Integration::Square::CatalogSyncedHandler < EventHandler
  on Integration::Square::Created

  def perform_async
    fetch_and_process_items
  end

  private

  def fetch_and_process_items(cursor: nil)
    response = square_client.catalog.list_catalog(types: 'ITEM', cursor:)
    process_items(response.data.objects)

    fetch_and_process_items(cursor: response.cursor) if response.cursor
  end

  def process_items(items)
    items.each do |item|
      organization.items.find_or_create_by(square_id: item[:id]) do |i|
        i.source = :catalog
        i.name = item.dig(:item_data, :name)
        i.description = item.dig(:item_data, :description)
      end
    end
  end

  def integration
    @integration ||= Integration::Square.find(event.id)
  end

  def organization
    @organization ||= integration.organization
  end

  def square_client
    ::Square::Client.new(
      access_token: integration.access_token,
      environment: ENV['SQUARE_ENVIRONMENT']
    )
  end
end
