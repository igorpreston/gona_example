class TestGenerator::Order
  STRIPE_PAYMENT_METHODS = %w[
    pm_card_visa
    pm_card_visa_debit
    pm_card_mastercard
    pm_card_mastercard_debit
    pm_card_mastercard_prepaid
    pm_card_amex
    pm_card_discover
    pm_card_diners
    pm_card_jcb
    pm_card_unionpay
  ].freeze

  class << self
    def create_sample_order(organization)
      location = find_random_active_location(organization)

      order = create_order(location)

      stripe_payment_intent = create_stripe_payment_intent(order)

      create_sample_payment_record!(order, stripe_payment_intent.id)
    end

    private

    def find_random_active_location(organization)
      organization.locations.select(&:active?).sample
    end

    def create_order(location)
      Order.create!(
        location:,
        user: User.all.sample,
        organization: location.organization,
        order_items: generate_order_items(location)
      )
    end

    def generate_order_items(location)
      rand(1..5).times.map do
        sample_item = location.organization.items.catalog.sample

        OrderItem.new(
          item: sample_item,
          quantity: rand(1..5),
          price_cents: sample_item.price_cents,
          currency: sample_item.currency
        )
      end
    end

    def create_stripe_payment_intent(order)
      ::Stripe::PaymentIntent.create(
        amount: order.amount_cents,
        application_fee_amount: order.application_fee_total_cents,
        currency: order.currency,
        capture_method: 'manual',
        confirm: true,
        payment_method: STRIPE_PAYMENT_METHODS.sample,
        transfer_data: {
          destination: order.organization.stripe_account_id
        },
        transfer_group: order.prefix_id,
        metadata: {
          order_id: order.prefix_id
        }
      )
    end

    def create_sample_payment_record!(order, stripe_payment_intent_id)
      order.payments.create!(
        organization: order.organization,
        currency: order.location&.currency || Rails.application.config.currency,
        user: order.user,
        amount_cents: order.amount_cents,
        subtotal_cents: order.subtotal_cents,
        tax_cents: order.tax_cents,
        application_fee_cents: order.application_fee_cents,
        stripe_payment_intent_id:
      )
    end
  end
end
