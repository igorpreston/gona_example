class Orders::StatusesController < ApplicationController
  def update
    if order.state_machine.transition_to(order_params[:status])
      redirect_to order, notice: "#{order.number} has been marked as #{order.status.humanize}."
    else
      redirect_to order, alert: "Unable to #{params[:status]} #{order.number}."
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

  def order
    @order ||= Order.find(params[:order_id])
  end
end
