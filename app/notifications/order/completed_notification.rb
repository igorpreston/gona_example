class Order::CompletedNotification < Noticed::Base
  include Rails.application.routes.url_helpers

  deliver_by :twilio, format: :twilio_format, credentials: :twilio_credentials, if: :production?

  param :order
  param :order_user

  def message
    t('notifications.order_completed.message')
  end

  def order
    params[:order]
  end

  def order_user
    params[:order_user]
  end

  def production?
    Rails.env.production?
  end

  def twilio_format
    {
      To: order_user.user_id.present? ? order_user.user&.phone : order_user.phone,
      From: ENV.fetch('TWILIO_PHONE_NUMBER', nil),
      Body: "Thank you for your order at #{order.organization&.name}!\n\n\nHere's your receipt: #{order_url(order,
                                                                                                            order_user)}"
    }
  end

  def twilio_credentials
    {
      account_sid: ENV.fetch('TWILIO_ACCOUNT_SID', nil),
      auth_token: ENV.fetch('TWILIO_AUTH_TOKEN', nil),
      phone_number: ENV.fetch('TWILIO_PHONE_NUMBER', nil)
    }
  end

  def order_url(_order, _order_user)
    url_for(
      controller: 'storefront/orders/order_users',
      action: :show,
      order_id: order.prefix_id,
      id: order_user.prefix_id,
      host: ENV.fetch('HOST', nil),
      protocol: ENV.fetch('PROTOCOL', nil),
      subdomain: :order
    )
  end
end
