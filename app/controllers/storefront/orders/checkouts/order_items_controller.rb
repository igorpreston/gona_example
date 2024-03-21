class Storefront::Orders::Checkouts::OrderItemsController < Storefront::BaseController
  def index
    render locals: { order:, order_items:, location: }
  end

  def destroy
    return unless order_item.destroy

    respond_to do |format|
      format.turbo_stream do
        render locals: { order:, order_item: }
      end
    end
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order_item
    @order_item ||= order.order_items.find(params[:id])
  end

  def location
    @location ||= order.location
  end

  def order_items
    @order_items ||= order.order_items
  end
end
