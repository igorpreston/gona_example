class Storefront::FrontPageController < Storefront::BaseController
  def show
    render locals: { locations: }
  end

  private

  def locations
    @locations ||= Location.includes(
      :address,
      {
        organization: { logo_attachment: :blob, cover_image_attachment: :blob }
      }
    ).where(organization: { status: :active })
  end
end
