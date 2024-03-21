class Organization::PayoutFailedNotification < Noticed::Base
  deliver_by :database
  deliver_by :sendgrid, class: DeliveryMethods::Sendgrid.name, request_body: :request_body, if: :production?

  SENDGRID_TEMPLATE_ID = 'd-6974d18d2686418c94f56bda6c2d5d6f'.freeze

  param :payout

  def production?
    Rails.env.production?
  end

  def payout
    params[:payout]
  end

  def organization
    payout.organization
  end

  def message
    "#{payout.prefix_id} Failed to be paid."
  end

  def request_body
    {
      personalizations: [
        {
          to: [
            {
              email: 'sergeyevanton@gmail.com'
            }
          ],
          dynamic_template_data: {
            name: payout.name,
            bank_name: payout.payment_method&.bank_name,
            last4: payout.payment_method&.last4,
            amount: payout.amount.format,
            currency: payout.currency&.upcase,
            reason: payout.failure_message,
            gona_contact_email: ENV.fetch('GONA_UNSTYLED_CONTACT_EMAIL', nil),
            gona_footer: ENV.fetch('GONA_FOOTER', nil),
            gona_privacy_url: ENV.fetch('GONA_PRIVACY', nil)
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
