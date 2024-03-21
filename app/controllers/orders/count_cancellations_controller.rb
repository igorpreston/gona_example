class Orders::CountCancellationsController < ApplicationController
  def show
    render layout: false, locals: { cancellations: }
  end

  private

  def cancellations
    cancellations = current_tenant.orders.where(
      cancelled_at: Date.today.all_day,
      status: :cancelled
    )
    cancellations = cancellations.where(location_id: params[:location_id]) if params[:location_id].present?
    cancellations.size
  end
end
