class Menus::LocationsController < ApplicationController
  def show
    render locals: { menu:, locations: }
  end

  private

  def menu
    @menu ||= Menu.find(params[:menu_id])
  end

  def locations
    @pagy, @locations = pagy(menu.locations, items: 5)
  end
end
