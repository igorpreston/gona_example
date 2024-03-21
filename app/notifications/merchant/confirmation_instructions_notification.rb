class Merchant::ConfirmationInstructionsNotification < Noticed::Base
  include Rails.application.routes.url_helpers

  deliver_by :sendgrid, class: DeliveryMethods::Sendgrid.name, request_body: :request_body, if: :production?

  SENDGRID_TEMPLATE_ID = 'd-4a18d92ee8ed44b583d2e58f7d1622a3'.freeze

  params :record, :token, :opts

  def record
    params[:record]
  end

  def token
    params[:token]
  end

  def production?
    Rails.env.production?
  end

  def request_body
    {
      personalizations: [
        {
          to: [
            {
              email: record.email
            }
          ],
          dynamic_template_data: {
            first_name: record.first_name,
            last_name: record.last_name,
            gona_contact_email: ENV.fetch('GONA_UNSTYLED_CONTACT_EMAIL', nil),
            gona_footer: ENV.fetch('GONA_FOOTER', nil),
            gona_privacy_url: ENV.fetch('GONA_PRIVACY', nil),
            confirmation_url: url_for(
              controller: 'merchants/confirmations',
              action: 'show',
              confirmation_token: token,
              host: ENV.fetch('HOST', nil),
              protocol: ENV.fetch('PROTOCOL', nil),
              subdomain: :business
            )
          }
        }
      ],
      from: {
        email: ENV.fetch('GONA_NOREPLY_EMAIL', nil)
      },
      template_id: SENDGRID_TEMPLATE_ID
    }
  end
end
