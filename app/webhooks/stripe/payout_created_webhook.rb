class Stripe::PayoutCreatedWebhook
  def call(event)
    stripe_payout = event
    organization = Organization.find_by(stripe_account_id: stripe_payout.account)

    return unless organization

    stripe_destination_id = stripe_payout.data.object.destination

    payment_method = sync_payment_method(organization, stripe_destination_id)

    sync_payout(organization, stripe_payout, payment_method)
  end

  private

  def sync_payment_method(organization, stripe_destination_id)
    payment_method = organization.payment_methods.find_by(processor_id: stripe_destination_id)

    return payment_method if payment_method

    stripe_bank = ::Stripe::Account.retrieve_external_account(organization.stripe_account_id, stripe_destination_id)

    organization.payment_methods.create(
      processor_id: stripe_bank.id,
      source_type: stripe_bank.object,
      data: stripe_bank,
      default: stripe_bank.try(:default_for_currency)
    )
  rescue ::Stripe::StripeError => e
    raise "#{self.class.name}##{__method__} #{e.message}"
  end

  def sync_payout(organization, stripe_payout, payment_method)
    organization.payouts.find_or_create_by(stripe_payout_id: stripe_payout.data.object.id) do |payout|
      payout.payment_method = payment_method
      payout.amount_cents = stripe_payout.data.object.amount
      payout.currency = stripe_payout.data.object.currency&.upcase
      payout.data = stripe_payout.data.object
    end
  end
end
