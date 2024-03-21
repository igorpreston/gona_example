class Orders::CountFulfillmentTimesController < ApplicationController
  def show
    render layout: false, locals: { fulfillment_time: }
  end

  private

  def fulfillment_time
    # average_time_seconds = current_tenant.orders.where(
    #   status: %i[completed],
    #   created_at: Date.today.all_day
    # )

    average_time_seconds = current_tenant.orders.where(
      created_at: Date.today.all_day
    ).where.not(
      ready_at: nil
    )

    average_time_seconds = average_time_seconds.where(
      location_id: params[:location_id]
    ) if params[:location_id].present?

    average_epoch_values = average_time_seconds.pluck(
      Arel.sql('extract(epoch from (ready_at - submitted_at))')
    ).compact

    return 0 if average_epoch_values.empty?

    average_time_minutes = average_epoch_values.sum / average_epoch_values.size / 60

    average_time_minutes.round(1)
  end
end
