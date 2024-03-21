class Storefront::Orders::OrderUsersController < Storefront::BaseController
  def show
    render locals: { order:, order_user: }
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order_user
    @order_user ||= order.order_users.find(params[:id])
  end
end
