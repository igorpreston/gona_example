class Stripe::CustomerSubscriptionCreatedWebhook
  def call(event)
    stripe_subscription = event.data.object

    organization = Organization.lock.find_by(stripe_customer_id: stripe_subscription.customer)

    return unless organization

    organization.subscriptions.create(
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

    organization.update(
      application_fee_type: :subscription,
      application_fee_rate: 0
    )
  end
end
