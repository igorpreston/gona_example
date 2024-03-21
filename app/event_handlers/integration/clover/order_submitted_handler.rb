class Integration::Clover::OrderSubmittedHandler < EventHandler
  on Order::Submitted

  def perform_async
    return nil unless integration.present? && !location.square_id?

    url = "#{base_url}/v3/merchants/#{organization.clover_id}/orders"
    headers = {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{integration.access_token}"
    }
    body = {
      currency: order.location&.currency || 'USD',
      total: order.amount_cents,
      payment_state: 'PAID',
      payType: 'FULL',
      title: order.table_id? ? "Table #{order.table_id} – ##{order.number}" : "##{order.number}",
      note: order.note&.body,
      payments: [
        {
          amount: order.amount_cents,
          merchant: {
            id: organization.clover_id
          },
          result: 'SUCCESS'
        }
      ],
      lineItems: order.order_items.map do |oi|
        {
          name: oi.item&.name,
          alternateName: oi.item&.name,
          price: oi.price_cents,
          priceWithModifiers: oi.total_with_options_cents,
          unitQty: oi.quantity,
          note: oi.note&.body
        }
      end
    }.to_json
    # byebug

    response = HTTParty.post(url, headers:, body:)
    order.update!(clover_id: response['id']) if response.success?
  end

  private

  def order
    @order ||= Order.find(event.id)
  end

  def location
    @location ||= order.location
  end

  def organization
    @organization ||= order.organization
  end

  def integration
    @integration ||= Integration::Clover.find_by(organization_id: organization.id)
  end

  def base_url
    Rails.env.production? ? Integration::Clover::BASE_URL_PRODUCTION_NA : Integration::Clover::BASE_URL_SANDBOX
  end
end
