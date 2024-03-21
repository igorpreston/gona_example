class Stripe::PayoutPaidWebhook
  def call(event)
    stripe_payout = event.data.object
    payout = Payout.find_by(stripe_payout_id: stripe_payout.id)

    return unless payout

    payout.update(data: stripe_payout)
  end
end
