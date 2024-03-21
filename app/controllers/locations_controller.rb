class LocationsController < ApplicationController
  def index
    render locals: { locations: }
  end

  def show
    render locals: { location: }
  end

  def new
    location = current_tenant.locations.new
    location.build_address

    render locals: { location: }
  end

  def create
    location = current_tenant.locations.build(location_params)

    if location.save!
      redirect_to location_path(location), notice: 'Location was successfully created.'
    else
      redirect_to locations_path, alert: 'Location could not be created.'
    end
  end

  def edit
    location.build_address unless location.address.present?

    render locals: { location: }
  end

  def update
    if location.update!(location_params)
      redirect_to location_path(location), notice: 'Location was successfully updated.'
    else
      render :edit, locals: { location: }
    end
  end

  def destroy
    if location.destroy!
      redirect_to locations_path, notice: 'Location was successfully destroyed.'
    else
      redirect_to locations_path, alert: 'Location could not be destroyed.'
    end
  end

  private

  def locations
    @pagy, @locations = pagy(
      current_tenant.locations.includes([:address]).order(name: :asc), items: 20
    )
  end

  def location
    @location ||= current_tenant.locations.find(params[:id])
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
        id line_one line_two city state zip country
      ]
    )
  end
end
