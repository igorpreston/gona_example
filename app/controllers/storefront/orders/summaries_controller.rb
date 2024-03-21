class Storefront::Orders::SummariesController < Storefront::BaseController
  def show
    render locals: { order:, location:, organization: }
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def location
    @location ||= order.location
  end

  def organization
    @organization ||= order.organization
  end
end
