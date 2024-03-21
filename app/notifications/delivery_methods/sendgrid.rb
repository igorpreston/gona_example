class DeliveryMethods::Sendgrid < Noticed::DeliveryMethods::Base
  option :request_body

  def deliver
    sendgrid = SendGrid::API.new(api_key: ENV.fetch('SMTP_PASSWORD', nil))

    begin
      response = sendgrid.client.mail._('send').post(request_body:)
      response.status_code
    rescue StandardError => e
      Rails.logger.error "[#{self.class.name}##{__method__}] #{e.message}"
      e.message
    end
  end

  def self.validate!(delivery_method_options)
    super

    return unless delivery_method_options[:request_body].blank?

    raise Noticed::ValidationError, 'You must pass a `request_body` option to `deliver_by :send_grid`'
  end

  private

  def request_body
    method_name = options[:request_body]&.to_sym

    if method_name.present?
      notification.respond_to?(method_name) ? notification.send(method_name) : method_name
    else
      notification.class.name.underscore
    end
  end
end
