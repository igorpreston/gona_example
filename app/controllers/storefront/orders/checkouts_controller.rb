class Storefront::Orders::CheckoutsController < Storefront::BaseController
  skip_before_action :verify_authenticity_token, only: :create, if: -> { request.format.turbo_stream? }

  def show
    return redirect_to location_path(location), allow_other_host: true if current_order_user.blank?
    return redirect_to location_path(location), allow_other_host: true if order.items_count.zero?
    return redirect_to location_path(location), allow_other_host: true unless order.draft? || order.dine_in?

    render locals: { order:, organization:, location:, payment: }
  end

  private

  def order
    @order ||= Order.lock.find(params[:order_id])
  end

  def organization
    @organization ||= order.organization
  end

  def location
    @location ||= order.location
  end

  def payment
    @payment ||= current_order_user&.payment&.tap do |p|
      p.update(
        organization:,
        currency: order.currency,
        amount_cents: order.amount_cents,
        subtotal_cents: order.subtotal_cents,
        tax_cents: order.tax_cents,
        application_fee_cents: order.application_fee_cents,
        application_fee_tax_cents: order.application_fee_tax_cents,
        application_fee_math: organization.application_fee_math
      )
    end
  end
end
