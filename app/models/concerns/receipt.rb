module Receipt
  include ActiveSupport::Concern

  def receipt
    Receipts::Receipt.new(
      id: prefix_id,
      product: 'Order',
      details: [
        ['Order Number:', "##{order.number}"],
        ['Receipt Number:', order.receipt_number],
        ['Payment Method:', payment_method],
        ['Order Date:', order.completed_at&.to_fs(:long)]
      ],
      recipient: [
        "Person #{position}"
      ],
      line_items:,
      company: {
        name: order.organization.legal_name || order.organization.name,
        email: order.organization.email,
        phone: order.organization.phone,
        address: order.location&.address&.to_s,
        logo: order.organization.logo&.url
      },
      footer: "We hope you enjoyed your experience with #{order.organization.name}!",
      logo_height: 50
    )
  end

  private

  def line_items
    items = order.order_items.flat_map do |order_item|
      item_lines = [[
        order_item.item.name,
        "x #{order_item.quantity}",
        order_item.price.format
      ]]

      option_lines = order_item.order_item_modifiers.flat_map do |oim|
        oim.order_item_options.map do |oio|
          [
            "- #{oio.option.item.name}",
            'x 1',
            oio.price.format
          ]
        end
      end

      item_lines + option_lines
    end

    items + [
      [nil, 'Subtotal', payment&.subtotal&.format],
      [nil, 'Tax', payment&.tax&.format],
      [nil, 'Total', payment&.amount&.format]
    ]
  end

  def payment_method
    if payment
      "#{payment.payment_method_details['card']['brand'].capitalize} / •••• #{payment.payment_method_details['card']['last4']}"
    else
      'Cash'
    end
  end
end
