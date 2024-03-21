class Payments::TransitionsController < ApplicationController
  def update
    if payment.state_machine.transition_to!(params[:status])
      redirect_to payment_path(payment), notice: "Payment has been marked as #{params[:status]}."
    else
      redirect_to payment_path(payment), alert: "Unable to #{params[:status]} payment."
    end
  end

  private

  def payment
    @payment ||= Payment.find(params[:payment_id])
  end
end
