class Square::OrderFulfillmentUpdatedWebhook
  def call(event)
    square_data = event.data.dig('data', 'object', 'order_fulfillment_updated')
    order_id = square_data['order_id']

    order = Order.find_by(square_id: order_id)
    return unless order

    new_state = square_data.dig('fulfillment_update', 0, 'new_state')
    status = map_square_state_to_order_state(new_state)

    order.state_machine.transition_to!(status)
  rescue StandardError => e
    Rails.logger.error("Square::OrderFulfillmentUpdatedWebhook: #{e.message}")
  end

  private

  def map_square_state_to_order_state(square_state)
    Integration::Square::SQUARE_STATE_TO_ORDER_STATE[square_state] || 'draft'
  end
end
