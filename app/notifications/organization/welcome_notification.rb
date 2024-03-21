class Organization::WelcomeNotification < Noticed::Base
  deliver_by :sendgrid, class: DeliveryMethods::Sendgrid.name, request_body: :request_body, if: :production?

  SENDGRID_TEMPLATE_ID = 'd-3406a56b736e4c34be734b602502af26'.freeze

  param :organization

  def production?
    Rails.env.production?
  end

  def organization
    params[:organization]
  end

  def message
    'Welcome to Gona!'
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
            organization_name: organization.name
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
