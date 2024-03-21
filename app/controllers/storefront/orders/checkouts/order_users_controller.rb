class Storefront::Orders::Checkouts::OrderUsersController < Storefront::BaseController
  skip_before_action :verify_authenticity_token, only: :create, if: -> { request.format.turbo_stream? }

  def show
    order_user = OrderUser.new

    render locals: { order_user:, order: }
  end

  def create
    phone = PhonyRails.normalize_number(order_user_params[:phone], country_code: order_user_params[:phone_country_code])
    @order_user = order.order_users.find_by(id: session[:order_user_id]).tap do |order_user|
      order_user.update!(phone:)
    end

    if @order_user.valid?
      respond_to do |format|
        format.turbo_stream do
          render locals: { order:, order_user: @order_user }
        end
      end
    else
      redirect_to location_path(order.location), alert: 'Your session has expired. Please try again.', turbo: false
    end
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order_user_params
    params.require(:order_user).permit(:phone, :phone_country_code)
  end
end
