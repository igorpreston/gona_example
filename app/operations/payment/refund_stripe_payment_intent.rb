class Payment::RefundStripePaymentIntent < Operation
  class Params < Operation::Params
    attribute :payment_id, Types::Coercible::String
  end

  class Response < Operation::Response
    attribute :payment_id, Types::Coercible::String
  end

  def perform
    refund_stripe_payment_intent!

    { payment_id: payment.id }
  end

  private

  def payment
    @payment ||= Payment.find(params.payment_id)
  end

  def refund_stripe_payment_intent!
    ::Stripe::Refund.create(payment_intent: payment.stripe_payment_intent_id)
  rescue ::Stripe::StripeError => e
    Rails.logger.error "#{self.class.name}##{__method__} #{e.message}"
  end
end
