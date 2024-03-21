class Feedback::ResponseCreatedNotification < Noticed::Base
  deliver_by :database
  deliver_by :twilio, format: :twilio_format, credentials: :twilio_credentials, if: :production?

  param :feedback
  param :order_user

  def feedback
    params[:feedback]
  end

  def order_user
    params[:order_user]
  end

  def production?
    # Rails.env.production?
    true
  end

  def twilio_format
    {
      To: order_user.user.present? ? order_user.user.phone : order_user.phone,
      From: ENV.fetch('TWILIO_PHONE_NUMBER', nil),
      Body: "#{feedback.organization.name} has responded to your feedback: #{feedback.response}"
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
