class Storefront::Orders::OrderUsers::FeedbacksController < Storefront::BaseController
  def show
    render locals: { order:, order_user: }
  end

  def create
    @feedback = order_user.build_feedback(
      feedback_params.merge(
        user: order_user.user,
        location: order.location,
        organization: order.organization,
        order:
      )
    )

    if @feedback.save
      redirect_to order_order_user_path(order, order_user), notice: 'Feedback was successfully created.'
    else
      redirect_to order_order_user_path(order, order_user), notice: 'Something went wrong.'
    end
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order_user
    @order_user ||= order.order_users.find(params[:order_user_id])
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :content, :notify)
  end
end
