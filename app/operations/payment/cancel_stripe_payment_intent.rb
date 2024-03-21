class Payment::CancelStripePaymentIntent < Operation
  class Params < Operation::Params
    attribute :payment_id, Types::Coercible::String
  end

  class Response < Operation::Response
    attribute :payment_id, Types::Coercible::String
  end

  def perform
    cancel_stripe_payment_intent!

    { payment_id: payment.id }
  end

  private

  def payment
    @payment ||= Payment.find(params.payment_id)
  end

  def cancel_stripe_payment_intent!
    ::Stripe::PaymentIntent.cancel(
      payment.stripe_payment_intent_id,
      { stripe_account: payment.organization.stripe_account_id }
    )
  rescue ::Stripe::StripeError => e
    Rails.logger.error "#{self.class.name}##{__method__} #{e.message}"
  end
end
