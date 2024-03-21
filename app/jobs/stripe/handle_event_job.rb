class Stripe::HandleEventJob < ApplicationJob
  queue_as :stripe

  def perform(event)
    handle_event(event)
  end

  private

  # Stripe events
  #
  # More information: https://stripe.com/docs/api/events/types
  #########################################################
  def handle_event(event)
    event = Stripe::Event.construct_from(event.data)

    case event.type
    when 'account.updated'
      handle_account_updated(event)

    when 'account.external_account.created'
      handle_account_external_account_created(event)
    when 'account.external_account.updated'
      handle_account_external_account_updated(event)
    when 'account.external_account.deleted'
      handle_account_external_account_deleted(event)

    when 'customer.created'
      handle_customer_created(event)
    when 'customer.updated'
      handle_customer_updated(event)
    when 'customer.deleted'
      handle_customer_deleted(event)

    when 'customer.subscription.created'
      handle_customer_subscription_created(event)
    when 'customer.subscription.updated'
      handle_customer_subscription_updated(event)
    when 'customer.subscription.deleted'
      handle_customer_subscription_deleted(event)

    when 'payment_method.attached'
      handle_payment_method_attached(event)
    when 'payment_method.updated'
      handle_payment_method_updated(event)
    when 'payment_method.detached'
      handle_payment_method_detached(event)

    when 'payment_intent.succeeded'
      handle_payment_intent_succeeded(event)
    when 'payment_intent.amount_capturable_updated'
      handle_payment_intent_amount_capturable_updated(event)
    when 'payment_intent.canceled'
      handle_payment_intent_cancelled(event)

    when 'charge.captured'
      handle_charge_captured(event)
    when 'charge.expired'
      handle_charge_expired(event)
    when 'charge.failed'
      handle_charge_failed(event)
    when 'charge.succeeded'
      handle_charge_succeeded(event)
    when 'charge.refunded'
      handle_charge_refunded(event)

    when 'payout.created'
      handle_payout_created(event)
    when 'payout.paid'
      handle_payout_paid(event)
    when 'payout.failed'
      handle_payout_failed(event)
    when 'payout.canceled'
      handle_payout_cancelled(event)

    else
      Rails.logger.info "[#{self.class.name}##{__method__}] Unhandled event type: #{event.type}"
    end
  end

  def handle_account_updated(event)
    Stripe::AccountUpdatedWebhook.new.call(event)
  end

  def handle_account_external_account_created(event)
    Stripe::AccountExternalAccountCreatedWebhook.new.call(event)
  end

  def handle_account_external_account_updated(event)
    Stripe::AccountExternalAccountUpdatedWebhook.new.call(event)
  end

  def handle_account_external_account_deleted(event)
    Stripe::AccountExternalAccountDeletedWebhook.new.call(event)
  end

  def handle_customer_created(event)
    Stripe::CustomerCreatedWebhook.new.call(event)
  end

  def handle_customer_updated(event)
    Stripe::CustomerUpdatedWebhook.new.call(event)
  end

  def handle_customer_deleted(event)
    Stripe::CustomerDeletedWebhook.new.call(event)
  end

  def handle_customer_subscription_created(event)
    Stripe::CustomerSubscriptionCreatedWebhook.new.call(event)
  end

  def handle_customer_subscription_updated(event)
    Stripe::CustomerSubscriptionUpdatedWebhook.new.call(event)
  end

  def handle_customer_subscription_deleted(event)
    Stripe::CustomerSubscriptionDeletedWebhook.new.call(event)
  end

  def handle_payment_method_attached(event)
    Stripe::PaymentMethodAttachedWebhook.new.call(event)
  end

  def handle_payment_method_updated(event)
    Stripe::PaymentMethodUpdatedWebhook.new.call(event)
  end

  def handle_payment_method_detached(event)
    Stripe::PaymentMethodDetachedWebhook.new.call(event)
  end

  def handle_payment_intent_amount_capturable_updated(event)
    Stripe::PaymentIntentAmountCapturableUpdatedWebhook.new.call(event)
  end

  def handle_payment_intent_cancelled(event)
    Stripe::PaymentIntentCancelledWebhook.new.call(event)
  end

  def handle_charge_captured(event)
    Stripe::ChargeCapturedWebhook.new.call(event)
  end

  def handle_charge_expired(event)
    Stripe::ChargeExpiredWebhook.new.call(event)
  end

  def handle_charge_failed(event)
    Stripe::ChargeFailedWebhook.new.call(event)
  end

  def handle_charge_succeeded(event)
    Stripe::ChargeSucceededWebhook.new.call(event)
  end

  def handle_charge_refunded(event)
    Stripe::ChargeRefundedWebhook.new.call(event)
  end

  def handle_payment_intent_succeeded(event)
    Stripe::PaymentIntentSucceededWebhook.new.call(event)
  end

  def handle_payout_created(event)
    Stripe::PayoutCreatedWebhook.new.call(event)
  end

  def handle_payout_paid(event)
    Stripe::PayoutPaidWebhook.new.call(event)
  end

  def handle_payout_failed(event)
    Stripe::PayoutFailedWebhook.new.call(event)
  end

  def handle_payout_cancelled(event)
    Stripe::PayoutFailedWebhook.new.call(event)
  end
end
