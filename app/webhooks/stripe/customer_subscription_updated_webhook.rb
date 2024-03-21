class Stripe::CustomerSubscriptionUpdatedWebhook
  def call(event)
    stripe_subscription = event.data.object
    subscription = Subscription.find_by(stripe_subscription_id: stripe_subscription.id)

    return unless subscription

    subscription.update(
      status: stripe_subscription.status,
      interval: stripe_subscription.plan.interval,
      stripe_plan_id: stripe_subscription.plan.id,
      stripe_customer_id: stripe_subscription.customer,
      stripe_subscription_id: stripe_subscription.id,
      quantity: stripe_subscription.quantity,
      canceled_at: stripe_subscription.canceled_at ? Time.at(stripe_subscription.canceled_at) : nil,
      trial_starts_at: stripe_subscription.trial_start ? Time.at(stripe_subscription.trial_start) : nil,
      trial_ends_at: stripe_subscription.trial_end ? Time.at(stripe_subscription.trial_end) : nil,
      ends_at: stripe_subscription.ended_at ? Time.at(stripe_subscription.ended_at) : nil
    )
  end
end
