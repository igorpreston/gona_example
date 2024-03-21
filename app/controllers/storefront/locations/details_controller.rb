class Storefront::Locations::DetailsController < Storefront::BaseController
  def show
    render locals: { location: }
  end

  private

  def location
    @location ||= Location.find(params[:location_id])
  end
end
