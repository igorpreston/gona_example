class MenusController < ApplicationController
  def index
    render locals: { menus: }
  end

  def show
    render locals: { menu: }
  end

  def new
    render locals: { menu: Menu.new }
  end

  def create
    menu = Menu.new(menu_params)

    if menu.save!
      redirect_to menu, notice: 'Menu created successfully'
    else
      render :new
    end
  end

  def edit
    render locals: { menu: }
  end

  def update
    if menu.update!(menu_params)
      redirect_to menu, notice: 'Menu updated successfully'
    else
      render :edit
    end
  end

  def destroy
    menu.destroy

    redirect_to menus_path, notice: 'Menu deleted successfully'
  end

  private

  def menu_params
    params.require(:menu).permit(
      :name,
      :description,
      schedule_attributes: %i[
        _destroy day_of_week start_local_time end_local_time
      ],
      location_ids: []
    )
  end

  def menus
    @pagy, @menus = pagy(Menu.includes(:locations).order(name: :asc), items: 20)
  end

  def menu
    @menu ||= Menu.find(params[:id])
  end
end
