class Organization::CreateStripeCustomer < Operation
  class Params < Operation::Params
    attribute :organization_id, Types::Coercible::String
  end

  class Response < Operation::Response
    attribute :organization_id, Types::Coercible::String
  end

  def perform
    create_stripe_customer!(create_params) unless organization.stripe_customer_id.present?

    { organization_id: organization.id }
  end

  private

  def organization
    @organization ||= Organization.find(params.organization_id)
  end

  def create_stripe_customer!(params)
    ::Stripe::Customer.create(params).tap do |customer|
      organization.update!(stripe_customer_id: customer.id)
    end
  rescue ::Stripe::StripeError => e
    Rails.logger.error "[#{self.class.name}##{__method__}] #{e.message}"
  end

  def create_params
    customer_params.merge!(address_params)
  end

  def customer_params
    {
      email: organization.email,
      phone: organization.phone,
      name: organization.legal_name,
      description: organization.description
    }.compact
  end

  def address_params
    {
      address: {
        line1: organization.address&.line_one,
        line2: organization.address&.line_two,
        city: organization.address&.city,
        state: organization.address&.state,
        postal_code: organization.address&.zip,
        country: organization.address&.country
      }
    }.compact
  end
end
