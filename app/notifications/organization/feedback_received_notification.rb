class Organization::FeedbackReceivedNotification < Noticed::Base
  deliver_by :database
  deliver_by :sendgrid,
             class: DeliveryMethods::Sendgrid.name,
             request_body: :request_body,
             if: :production?

  SENDGRID_TEMPLATE_ID = 'd-6b23236ab63f42259a9ad4835f65819e'.freeze

  param :feedback

  def production?
    Rails.env.production?
  end

  def message
    "#{feedback&.user&.name} has left you feedback."
  end

  def feedback
    params[:feedback]
  end

  def user
    feedback.user
  end

  def organization
    feedback.organization
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
            first_name: user.first_name,
            gona_contact_email: ENV.fetch('GONA_UNSTYLED_CONTACT_EMAIL', nil),
            gona_footer: ENV.fetch('GONA_FOOTER', nil),
            gona_privacy_url: ENV.fetch('GONA_PRIVACY', nil),
            feedback_message: params[:feedback].content,
            rating: "#{params[:feedback].rating} out of #{Feedback::MAX_RATING}"
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
