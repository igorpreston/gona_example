class Storefront::Locations::MenusController < Storefront::LocationsController
  def show
    render locals: { menu:, order: @order }
  end

  private

  def location
    @location ||= Location.find(params[:location_id])
  end

  def menu
    @menu ||= location.current_menus.find(params[:id])
  end
end
