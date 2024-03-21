class Storefront::Orders::EqualSplitsController < Storefront::BaseController
  def show; end

  def update
    order.update(number_of_people: params[:number_of_people])
    order_user.update(paying_for: params[:paying_for])
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order_user
    @order_user ||= order.order_users.find_by(id: session[:order_user_id])
  end
end
