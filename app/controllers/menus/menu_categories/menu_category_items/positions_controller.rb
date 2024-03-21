class Menus::MenuCategories::MenuCategoryItems::PositionsController < ApplicationController
  def update
    head :ok if menu_category_item.insert_at(params[:position].to_i)
  end

  private

  def menu_category_item
    @menu_category_item ||= MenuCategoryItem.find(params[:menu_category_item_id])
  end
end
