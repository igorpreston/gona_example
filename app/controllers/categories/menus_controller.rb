class Categories::MenusController < ApplicationController
  def show
    render locals: { category:, menus: }
  end

  private

  def category
    @category ||= current_tenant.categories.find(params[:category_id])
  end

  def menus
    @pagy, @menus = pagy(category.menus.order(name: :asc), items: 5)
  end
end
