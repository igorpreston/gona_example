class Storefront::Locations::Orders::OrderItemsController < Storefront::BaseController
  def destroy
    order_item.destroy if order_item.added?

    respond_to do |format|
      format.turbo_stream do
        render locals: { order:, order_item:, location: }
      end
    end
  end

  private

  def location
    @location ||= Location.find(params[:location_id])
  end

  def order
    @order ||= location.orders.find(params[:order_id])
  end

  def order_item
    @order_item ||= order.order_items.find(params[:id])
  end
end
