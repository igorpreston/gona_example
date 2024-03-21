class Storefront::Orders::Feedbacks::LocationsController < Storefront::BaseController
  def show
    render locals: { order:, location:, organization: }
  end

  def create
    feedback = location.feedbacks.create!(
      feedback_params.merge(
        user: order.user,
        organization:
      )
    )

    respond_to do |format|
      format.turbo_stream do
        render locals: { organization:, order:, location:, feedback: }
      end
    end
  end

  private

  def order
    @order ||= Order.find(params[:order_id])
  end

  def location
    @location ||= order.location
  end

  def organization
    @organization ||= order.organization
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :content)
  end
end
