class Storefront::LocationsController < Storefront::BaseController
  before_action :order, only: %i[show]
  before_action :order_user, only: %i[show]

  def show
    render locals: { location:, organization:, order: }
  end

  private

  def location
    @location ||= Location.includes(:organization).find(params[:id])
  end

  def organization
    @organization ||= location.organization
  end

  def order
    @order ||= if table.present?
                 table.orders.find_or_create_by!(
                   location:,
                   organization: location.organization,
                   status: :ongoing,
                   table:,
                   preference: :dine_in
                 )
               else
                 current_cart.orders.find_or_create_by!(
                   location:,
                   organization: location.organization,
                   status: :draft,
                   preference: :take_out,
                   payment_split_type: :individual
                 )
               end

    session[:order_id] = @order.id

    @order
  end

  def order_user
    @order_user ||= order.order_users.find_by(id: session[:order_user_id]) if session[:order_user_id].present?

    @order_user ||= order.order_users.create! if @order_user.blank?

    session[:order_user_id] = @order_user.id

    @order_user
  end

  def table
    @table ||= location.tables.find(params[:table_id]) if params[:table_id].present?
  end
end
