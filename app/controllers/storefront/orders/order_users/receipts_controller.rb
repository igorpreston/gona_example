class Storefront::Orders::OrderUsers::ReceiptsController < Storefront::BaseController
  def show
    respond_to do |format|
      format.pdf do
        send_data(
          order_user.receipt.render,
          filename: "#{order.receipt_number}.pdf",
          type: 'application/pdf',
          disposition: :inline
        )
      end
    end
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order_user
    @order_user ||= order.order_users.find(params[:order_user_id])
  end
end
