class Categories::CategoryItemsController < ApplicationController
  def create
    category_item = category.category_items.create(item:)

    respond_to do |format|
      format.turbo_stream do
        render locals: { category:, category_item: }
      end
    end
  end

  def destroy
    category_item.destroy

    respond_to do |format|
      format.turbo_stream do
        render locals: { category:, category_item: }
      end
    end
  end

  private

  def category
    @category ||= current_tenant.categories.find(params[:category_id])
  end

  def item
    @item ||= current_tenant.items.find(params[:item_id])
  end

  def category_item
    @category_item ||= category.category_items.find(params[:id])
  end

  def category_item_params
    params.require(:category_item).permit(:category_id, :item_id)
  end
end
