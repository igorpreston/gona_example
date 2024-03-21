class Storefront::TablesController < Storefront::BaseController
  before_action :order, only: %i[show]
  before_action :order_user, only: %i[show]
  before_action :location, only: %i[show]
  before_action :organization, only: %i[show]
  before_action :table, only: %i[show]

  def show
    render locals: { table:, location:, organization:, order: }
  end

  private

  def table
    @table ||= Table.find(params[:id])
  end

  def location
    @location ||= table.location
  end

  def organization
    @organization ||= table.organization
  end

  def order
    @order ||= table.orders.find_or_create_by!(
      location:,
      organization:,
      table:,
      status: :ongoing,
      preference: :dine_in
    )
  end

  def order_user
    @order_user ||= order.order_users.find_by(id: session[:order_user_id])

    @order_user = order.order_users.create! if @order_user.blank?

    session[:order_user_id] = @order_user.id
  end
end
