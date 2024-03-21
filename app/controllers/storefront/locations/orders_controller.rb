class Storefront::Locations::OrdersController < Storefront::BaseController
  def show
    render locals: { location:, order: }
  end

  def update
    order.state_machine.transition_to!(:ongoing) unless order.state_machine.current_state == 'ongoing'

    order.order_items.includes(:item).where(status: :added).update(status: :unpaid)

    redirect_to table_path(
      order.table,
      subdomain: :order
    ), notice: 'We are preparing your order!'
  end

  private

  def order
    @order ||= location.orders.find(params[:id])
  end

  def location
    @location ||= Location.find(params[:location_id])
  end

  def organization
    @organization ||= order.organization
  end
end
