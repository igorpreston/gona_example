class Menus::MenuCategoriesController < ApplicationController
  def new
    menu_category = menu.menu_categories.build
    menu_category.build_category

    render locals: { menu:, menu_category: }
  end

  def create
    menu_category = menu.menu_categories.build(menu_category_params)

    if menu_category.save
      respond_to do |format|
        format.turbo_stream do
          render locals: { menu:, menu_category: }
        end
      end
    else
      render :new, locals: { menu:, menu_category: }
    end
  end

  def edit
    render locals: { menu:, menu_category: }
  end

  def update
    if menu_category.update(menu_category_params)
      respond_to do |format|
        format.turbo_stream do
          render locals: { menu:, menu_category: }
        end
      end
    else
      render :edit, locals: { menu:, menu_category: }
    end
  end

  def destroy
    if menu_category.destroy
      redirect_to menu_path(menu), notice: 'Menu category was successfully destroyed.'
    else
      render :edit, locals: { menu:, menu_category: }
    end
  end

  private

  def menu
    @menu ||= current_tenant.menus.find(params[:menu_id])
  end

  def menu_category
    @menu_category ||= menu.menu_categories.find(params[:id])
  end

  def menu_category_params
    params.require(:menu_category).permit(category_attributes: [:name])
  end
end
