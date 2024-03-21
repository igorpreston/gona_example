class Order::CancelledNotification < Noticed::Base
  deliver_by :database
  deliver_by :twilio, format: :twilio_format, credentials: :twilio_credentials, if: :production?

  param :order
  param :order_user

  def order
    params[:order]
  end

  def order_user
    params[:order_user]
  end

  def message
    t('notifications.order_cancelled.message', organization: params[:order].organization.name)
  end

  def production?
    Rails.env.production?
  end

  def twilio_format
    {
      To: order_user.user.present? ? order_user.user.phone : order_user.phone,
      From: ENV.fetch('TWILIO_PHONE_NUMBER', nil),
      Body: 'Your order has been cancelled. We apologize for the inconvenience. Your money will be refunded shortly.'
    }
  end

  def twilio_credentials
    {
      account_sid: ENV.fetch('TWILIO_ACCOUNT_SID', nil),
      auth_token: ENV.fetch('TWILIO_AUTH_TOKEN', nil),
      phone_number: ENV.fetch('TWILIO_PHONE_NUMBER', nil)
    }
  end
end
