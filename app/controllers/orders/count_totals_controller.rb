class Orders::CountTotalsController < ApplicationController
  def show
    render layout: false, locals: { total: }
  end

  private

  def total
    total = current_tenant.orders.where(
      created_at: DateTime.current.localtime.beginning_of_day..DateTime.current.end_of_day
    ).where.not(status: :draft)
    total = total.where(location_id: params[:location_id]) if params[:location_id].present?
    total.size
  end
end
