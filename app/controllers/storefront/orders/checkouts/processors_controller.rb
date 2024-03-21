class Storefront::Orders::Checkouts::ProcessorsController < Storefront::BaseController
  def show
    render locals: { order: }
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end
end
