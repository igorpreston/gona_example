class PaymentsController < ApplicationController
  def index
    render locals: { payments: }
  end

  def show
    render locals: { payment: }
  end

  private

  def payments
    @pagy, @payments = pagy(Payment.includes([:user]).order(created_at: :desc).all, items: 20)
  end

  def payment
    @payment ||= Payment.find(params[:id])
  end
end
