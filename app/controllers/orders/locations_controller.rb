class Orders::LocationsController < ApplicationController
  def show
    render layout: false, locals: { locations: }
  end

  private

  def locations
    @locations ||= current_tenant.locations.order(name: :asc)
  end
end
