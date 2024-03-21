class Organization::PayoutPaidNotification < Noticed::Base
  deliver_by :database
  deliver_by :sendgrid, class: DeliveryMethods::Sendgrid.name, request_body: :request_body, if: :production?

  SENDGRID_TEMPLATE_ID = 'd-f08e72f3224c4be4b90a21c7944e99b4'.freeze

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
    "Payout of #{payout.amount.format} has been sent to #{organization.name}"
  end

  def request_body
    {
      personalizations: [
        {
          to: [
            {
              email: organization.email
            }
          ],
          dynamic_template_data: {
            name: payout.name,
            bank_name: payout.payment_method&.bank_name,
            last4: payout.payment_method&.last4,
            amount: payout.amount.format,
            currency: payout.currency&.upcase,
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
