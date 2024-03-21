module Pricing
  extend ActiveSupport::Concern

  def currency
    location.currency || Rails.application.config.currency
  end

  def subtotal_cents
    order_items.sum(&:total_with_options_cents).round
  end

  def subtotal
    Money.new(subtotal_cents, currency)
  end

  def application_fee_rate
    organization.application_fee_rate
  end

  def application_fee_cents
    (subtotal_cents * application_fee_rate).round
  end

  def application_fee
    Money.new(application_fee_cents, currency)
  end

  def application_fee_percentage
    application_fee_rate * 100
  end

  def tax_rate
    location.tax_rate
  end

  def tax_cents
    taxable_amount = subtotal_cents
    taxable_amount += application_fee_cents if organization.fee_added?
    (taxable_amount * tax_rate).round
  end

  def tax
    Money.new(tax_cents, currency)
  end

  def tax_percentage
    tax_rate * 100
  end

  def amount_cents
    total = subtotal_cents + tax_cents
    total += application_fee_cents if organization.fee_added?
    total.round
  end

  def amount
    Money.new(amount_cents, currency)
  end

  def application_fee_total_cents
    # Total application fee including any taxes on the fee itself
    total_fee = application_fee_cents
    total_fee += application_fee_tax_cents if organization.fee_added? && tax_applies_to_application_fee?
    total_fee.round
  end

  def application_fee_tax_cents
    # Calculate the tax on the application fee
    (application_fee_cents * tax_rate).round
  end

  private

  def tax_applies_to_application_fee?
    # Implement logic to determine if tax applies to the application fee
    # This could be a simple flag or a more complex decision based on business rules
    true # Example, set this according to your business logic
  end
end
