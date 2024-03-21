class Storefront::OrdersController < Storefront::BaseController
  def show
    render locals: { order: }
  end

  def update
    order.update(payment_split_type: params[:payment_split_type])

    respond_to do |format|
      format.turbo_stream do
        render locals: { order: }
      end
    end
  end

  def destroy
    order.order_items&.destroy_all

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            :order,
            partial: 'storefront/locations/orders/order',
            locals: { order:, location: order.location }
          )
        ]
      end
    end
  end

  private

  def order
    @order ||= Order.find(params[:id])
  end
end
