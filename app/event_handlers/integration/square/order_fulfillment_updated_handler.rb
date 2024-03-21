class Integration::Square::OrderFulfillmentUpdatedHandler < EventHandler
  include SquareClient

  on Order::InProgress, Order::Ready, Order::Completed, Order::Cancelled

  def perform_async
    return unless integration.present?

    square_client.orders.update_order(
      order_id: order.square_id,
      body: {
        order: {
          location_id: order.location&.square_id,
          fulfillments: [
            {
              uid: square_order[:fulfillments].first[:uid],
              state: Integration::Square::SQUARE_STATE_TO_ORDER_STATE.key(order.status)
            }
          ],
          version: square_order[:version]
        }
      }
    )
  end

  private

  def order
    @order ||= Order.includes(:items).find(event.id)
  end

  def integration
    @integration ||= Integration::Square.find_by(organization_id: order.organization_id)
  end

  def square_client
    square_client(integration)
  end

  def square_order
    square_client.orders.retrieve_order(order_id: order.square_id).data.order
  end
end
