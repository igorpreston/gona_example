class OrdersController < ApplicationController
  def index
    render locals: { orders: }
  end

  def show
    render locals: { order:, order_items: }
  end

  def create
    ::TestGenerator::Order.create_sample_order(current_tenant)

    redirect_to orders_path, notice: 'Page refreshed. Order created.'
  end

  def update; end

  private

  def order_params
    params.require(:order).permit(:preference, :location_id, item_ids: [])
  end

  def orders
    orders = Order.includes(:location)
                  .where.not(status: :draft)
                  .order(submitted_at: :desc)

    orders = orders.where(location_id: params[:location_id]) if params[:location_id].present?
    orders = orders.where(status: params[:status]) if params[:status].present?

    @pagy, @orders = pagy(orders, items: 20)
  end

  def order
    @order ||= Order.find(params[:id])
  end

  def order_items
    @order_items ||= order.order_items.includes([item: [photo_attachment: :blob]]).order(created_at: :desc)
  end
end
