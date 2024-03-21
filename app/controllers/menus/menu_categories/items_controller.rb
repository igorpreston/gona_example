class Menus::MenuCategories::ItemsController < ApplicationController
  def show
    results = current_tenant.items.where(
      'name ILIKE ? AND source = ?', "%#{params[:query]}%", 'catalog'
    ).includes(photo_attachment: :blob).where.not(
      id: menu_category.items&.pluck(:id)
    ).order(:name)

    @pagy, @items = pagy(results, items: 5)

    render locals: { menu_category:, items: @items }
  end

  def create
    menu_category_item = menu_category.menu_category_items.build(item:)

    if menu_category_item.save
      respond_to do |format|
        format.turbo_stream do
          render locals: { menu:, menu_category:, item: }
        end
      end
    else
      render locals: { menu:, menu_category:, item: }
    end
  end

  private

  def menu
    @menu ||= current_tenant.menus.find(params[:menu_id])
  end

  def item
    @item ||= current_tenant.items.find(params[:item_id])
  end

  def menu_category
    @menu_category ||= menu.menu_categories.find(params[:menu_category_id])
  end
end
