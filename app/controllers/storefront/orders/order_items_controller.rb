class Storefront::Orders::OrderItemsController < Storefront::BaseController
  skip_before_action :verify_authenticity_token, only: :create, if: -> { request.format.turbo_stream? }

  def new
    render locals: { order:, order_item:, menu_category_item: }
  end

  def create
    order_item = OrderItem.new(
      order_item_params.merge(
        price_cents: item.price_cents,
        currency: item.currency
      )
    )

    if order_item.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              :order,
              partial: "storefront/locations/orders/#{order.preference&.underscore}",
              locals: { order:, location: order.location }
            ),
            turbo_stream.update(
              :modal,
              ''
            )
          ]
        end
      end
    else
      render :new
    end
  end

  def edit
    render locals: { order:, order_item: }
  end

  def update
    if order_item.update(order_item_params)
      respond_to do |format|
        format.turbo_stream do
          render locals: { order_item:, order:, payment: current_order_user&.payment }
        end
      end
    else
      render :edit
    end
  end

  def destroy
    order.order_items.find(params[:order_item_id]).destroy
  end

  private

  def order_item_params
    params.require(:order_item).permit(
      :order_id,
      :item_id,
      :quantity,
      note_attributes: %i[
        id
        body
      ],
      order_item_modifiers_attributes: [
        :id,
        :modifier_id,
        :option_ids,
        { option_ids: [] }
      ]
    )
  end

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order_item
    @order_item ||= order.order_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    order.order_items.build.tap do |order_item|
      order_item.build_note
    end
  end

  def item
    @item ||= Item.find(order_item_params[:item_id])
  end

  def menu_category_item
    @menu_category_item ||= MenuCategoryItem.find(params[:menu_category_item_id])
  end
end
