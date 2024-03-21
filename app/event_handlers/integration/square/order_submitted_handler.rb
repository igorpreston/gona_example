class Integration::Square::OrderSubmittedHandler < EventHandler
  include SquareClient

  on Order::Submitted

  # Square API Reference: https://developer.squareup.com/reference/square/orders-api/create-order
  #
  # NOTE:
  #  - Square API requires a location_id to be specified in the request body
  #  - Square API requires a pickup_at to be specified in the request body
  #  - Square API requires a pickup_details.recipient.display_name to be specified in the request body
  #  - Square API requires an order to be fulfilled and paid in order to display in Square Dashboard and Square POS
  def perform_async
    return nil unless integration.present? && location.square_id.present?

    square_client = square_client(integration)

    order_response = square_client.orders.create_order(body: generate_order_body(order))

    raise order_response.errors unless order_response.success?

    order.update!(square_id: order_response.data.dig(:order, :id))

    payment_response = square_client.payments.create_payment(body: generate_payment_body(order_response.data))

    raise payment_response.errors unless payment_response.success?
  end

  private

  def order
    @order ||= Order.find(event.id)
  end

  def integration
    @integration ||= Integration::Square.find_by(organization_id: order.organization_id)
  end

  def location
    @location ||= order.location
  end

  def generate_order_body(order)
    {
      order: {
        location_id: order.location&.square_id,
        reference_id: order.number,
        source: {
          name: order.table_id.present? ? "#{order.table&.name} – GONA" : 'GONA'
        },
        ticket_name: order.table_id.present? ? "#{order.table&.name} – GONA" : 'GONA',
        line_items: order.order_items.map do |order_item|
          {
            name: order_item.item&.name,
            quantity: order_item.quantity.to_s,
            note: order_item.note&.body,
            item_type: 'ITEM',
            base_price_money: {
              amount: order_item.price_cents,
              currency: order_item.currency
            },
            modifiers: order_item.order_item_modifiers.map do |oim|
              oim.order_item_options.map do |oio|
                {
                  name: oio.option&.item&.name,
                  base_price_money: {
                    amount: oio.price_cents,
                    currency: oio.currency
                  }
                }
              end
            end.flatten
          }
        end,
        taxes: [
          {
            name: 'Tax',
            type: 'ADDITIVE',
            percentage: (order.location.tax_rate * 100).to_s,
            applied_money: {
              amount: order.tax_cents,
              currency: order.location&.currency
            },
            scope: 'ORDER'
          }
        ],
        fulfillments: [
          {
            type: order.take_out? || order.dine_in? ? 'PICKUP' : 'DELIVERY',
            pickup_details: {
              recipient: {
                display_name: order.user&.name || 'Guest'
              },
              pickup_at: (DateTime.now + 30.minutes).iso8601
            }
          }
        ]
      },
      idempotency_key: SecureRandom.uuid
    }
  end

  def generate_payment_body(data)
    {
      source_id: 'EXTERNAL',
      idempotency_key: SecureRandom.uuid,
      amount_money: {
        amount: data.dig(:order, :total_money, :amount),
        currency: data.dig(:order, :total_money, :currency)
      },
      order_id: data.dig(:order, :id),
      location_id: data.dig(:order, :location_id),
      external_details: {
        type: 'CARD',
        source: 'GONA'
      }
    }
  end
end
