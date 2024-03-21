class Orders::CountFulfilledsController < ApplicationController
  def show
    render layout: false, locals: { fulfilled: }
  end

  private

  def fulfilled
    fulfilled = current_tenant.orders.where(
      completed_at: Date.today.all_day,
      status: :completed
    )
    fulfilled = fulfilled.where(location_id: params[:location_id]) if params[:location_id].present?
    fulfilled.size
  end
end
