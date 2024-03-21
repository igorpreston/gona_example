class Stripe::ChargeCapturedWebhook
  def call(event)
    stripe_charge = event.data.object
    payment = find_payment(stripe_charge.payment_intent)

    return unless payment

    update_payment(payment, stripe_charge)
    create_transfer_if_applicable(payment, stripe_charge) if fee_added?(payment)
  end

  private

  def find_payment(payment_intent_id)
    Payment.find_by(stripe_payment_intent_id: payment_intent_id)
  end

  def update_payment(payment, stripe_charge)
    payment.update(latest_charge_data: stripe_charge, paid_at: Time.current)
  end

  def fee_added?(payment)
    return false if payment.organization&.application_fee_rate&.zero?

    payment.application_fee_math == Organization.application_fee_maths[:fee_added]
  end

  def create_transfer_if_applicable(payment, stripe_charge)
    stripe_account_id = payment.organization&.stripe_account_id
    return unless stripe_account_id

    stripe_payment_intent = retrieve_payment_intent(stripe_charge.payment_intent, stripe_account_id)
    transfer_application_fee(payment, stripe_payment_intent) if stripe_payment_intent
  end

  def retrieve_payment_intent(payment_intent_id, stripe_account_id)
    ::Stripe::PaymentIntent.retrieve(payment_intent_id, stripe_account: stripe_account_id)
  rescue Stripe::StripeError => e
    # Log error or handle exception
    nil
  end

  def transfer_application_fee(payment, stripe_payment_intent)
    return unless destination_account_id

    begin
      ::Stripe::Transfer.create(
        {
          amount: payment.application_fee_cents + payment.application_fee_tax_cents,
          currency: payment.currency,
          destination: destination_account_id,
          transfer_group: stripe_payment_intent.transfer_group
        },
        stripe_account: payment.organization&.stripe_account_id
      )
    rescue Stripe::StripeError => e
      # Log error or handle exception
    end
  end

  def destination_account_id
    ENV.fetch('STRIPE_ACCOUNT_ID', nil)
  end
end
