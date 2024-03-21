class Organizations::LocationsController < ApplicationController
  def index
    render locals: { organization:, locations: }
  end

  def new
    location = Location.new
    location.build_address

    render locals: { organization:, location: }
  end

  def create
    location = current_tenant.locations.create!(location_params)

    if location.persisted?
      redirect_to organization_locations_path, notice: 'Location was successfully created.'
    else
      redirect_to new_organization_location_path, alert: 'Location could not be created.'
    end
  end

  def edit
    render locals: { organization:, location: }
  end

  def update
    if location.update(location_params)
      redirect_to organization_locations_path, notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    location.destroy

    redirect_to organization_locations_path, notice: 'Location was successfully destroyed.'
  end

  private

  def organization
    @organization ||= current_tenant
  end

  def location_params
    params.require(:location).permit(
      :name,
      :phone,
      :email,
      :location_type,
      :pickup_instructions,
      :expected_preparation_time_seconds,
      :auto_accept_order,
      :timezone,
      :tax_rate,
      schedule_attributes: %i[
        _destroy day_of_week start_local_time end_local_time
      ],
      address_attributes: %i[
        line_one line_two city state zip country
      ]
    )
  end

  def locations
    @pagy, @locations = pagy(organization.locations.includes(:address), items: 20)
  end

  def location
    @location ||= Location.find(params[:id])
  end
end
