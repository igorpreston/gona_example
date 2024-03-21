class Storefront::Orders::Checkouts::StripePaymentsController < Storefront::BaseController
  skip_before_action :verify_authenticity_token, only: :create, if: -> { request.format.turbo_stream? }

  def show
    create_payment_intent(payment) if payment.stripe_payment_intent_id.blank?
    update_payment_intent(payment) if payment.stripe_payment_intent_id.present?

    render locals: { order:, payment:, payment_intent: @payment_intent }
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def organization
    @organization ||= order.organization
  end

  def payment
    @payment ||= order.payments.find_or_create_by(
      order_user_id: current_order_user.id,
      status: :created
    ).tap do |payment|
      payment.update!(
        organization: order.organization,
        user: current_order_user.user,
        amount_cents: order.amount_cents,
        subtotal_cents: order.subtotal_cents,
        tax_cents: order.tax_cents,
        application_fee_cents: order.application_fee_cents,
        application_fee_tax_cents: order.application_fee_tax_cents,
        application_fee_math: organization.application_fee_math,
        currency: order.currency
      )
    end
  end

  def create_payment_intent(payment)
    @payment_intent = ::Stripe::PaymentIntent.create(
      {
        amount: payment.amount_cents,
        currency: payment.currency,
        application_fee_amount: payment.application_fee_cents + payment.application_fee_tax_cents,
        description: "Order ID: #{order.prefix_id}",
        capture_method: 'manual',
        metadata: {
          order_id: order.prefix_id,
          order_number: order.number
        }
      },
      {
        stripe_account: organization&.stripe_account_id
      }
    ).tap do |pi|
      payment.update!(
        stripe_payment_intent_id: pi.id,
        status: :created
      )
    end
  end

  def update_payment_intent(payment)
    ::Stripe::PaymentIntent.update(
      payment.stripe_payment_intent_id,
      {
        amount: payment.amount_cents,
        application_fee_amount: payment.application_fee_cents + payment.application_fee_tax_cents
      },
      stripe_account: organization&.stripe_account_id
    )

    @payment_intent = ::Stripe::PaymentIntent.retrieve(
      payment.stripe_payment_intent_id,
      {
        stripe_account: organization&.stripe_account_id
      }
    )
  end
end
