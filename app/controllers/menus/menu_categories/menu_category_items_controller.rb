class Menus::MenuCategories::MenuCategoryItemsController < ApplicationController
  def new
    menu_category_item = menu_category.menu_category_items.build
    menu_category_item.build_item(source: 'catalog')

    render locals: { menu:, menu_category:, menu_category_item: }
  end

  def create
    menu_category_item = menu_category.menu_category_items.build(menu_category_item_params)
    menu_category_item.item&.source = 'catalog'

    if menu_category_item.save!
      respond_to do |format|
        format.turbo_stream do
          render locals: {
            menu:,
            menu_category:,
            menu_category_item:
          }
        end
      end
    else
      render :new, locals: {
        menu:,
        menu_category:,
        menu_category_item:
      }
    end
  end

  def edit
    render locals: { menu:, menu_category:, menu_category_item: }
  end

  def update
    menu_category_item.update!(menu_category_item_params)

    respond_to do |format|
      format.turbo_stream do
        render locals: {
          menu:,
          menu_category:,
          menu_category_item:
        }
      end
    end
  end

  def destroy
    if menu_category_item.destroy
      redirect_to menu_path(menu), notice: 'Menu category item was successfully destroyed.'
    else
      render :edit, locals: {
        menu:,
        menu_category:,
        menu_category_item:
      }
    end
  end

  private

  def menu
    @menu ||= current_tenant.menus.find(params[:menu_id])
  end

  def menu_category
    @menu_category ||= menu.menu_categories.find(params[:menu_category_id])
  end

  def menu_category_item
    @menu_category_item ||= menu_category.menu_category_items.find(params[:id])
  end

  def menu_category_item_params
    params.require(:menu_category_item).permit(
      item_attributes: [
        :id,
        :name,
        :price,
        :photo,
        :description,
        {
          metadata: %i[
            energy_cal
            energy_kj
            temperature
            vegan
            vegetarian
            gluten_free
            spicy
          ]
        },
        { modifier_ids: [] }
      ]
    )
  end
end
