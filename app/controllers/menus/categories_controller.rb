class Menus::CategoriesController < ApplicationController
  def show
    results = current_tenant.categories.where(
      'name ILIKE ?', "%#{params[:query]}%"
    ).where.not(
      id: menu.menu_categories.pluck(:category_id)
    ).order(name: :desc)

    @pagy, @categories = pagy(results, items: 5)

    render locals: { menu:, categories: @categories }
  end

  def create
    menu_category = menu.menu_categories.build(category:)
    menu_category.items << category.items

    if menu_category.save
      respond_to do |format|
        format.turbo_stream do
          render locals: { menu:, category: }
        end
      end
    else
      render locals: { menu:, category: }
    end
  end

  private

  def menu
    @menu ||= current_tenant.menus.find(params[:menu_id])
  end

  def category
    @category ||= current_tenant.categories.find(params[:category_id])
  end
end
