class Locations::MenusController < ApplicationController
  def show
    render locals: { location:, menus: }
  end

  private

  def location
    @location ||= current_tenant.locations.find(params[:location_id])
  end

  def menus
    @pagy, @menus = pagy(
      location.menus.order(:name),
      items: 10
    )
  end
end
