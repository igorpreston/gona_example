class Locations::TablesController < ApplicationController
  def index
    render locals: { location:, tables: }
  end

  def new
    table = Table.new

    render locals: { table: }
  end

  def create
    table = location.tables.build(table_params)

    if table.save!
      redirect_to location_path(location), notice: 'Table created'
    else
      render :new, locals: { table: }
    end
  end

  def edit
    render locals: { table: }
  end

  def update
    if table.update(table_params)
      redirect_to location_path(location), notice: 'Table updated'
    else
      render :edit, locals: { table: }
    end
  end

  def destroy
    table.destroy!

    redirect_to location_path(location), notice: 'Table deleted'
  end

  private

  def table_params
    params.require(:table).permit(:name, :location_id)
  end

  def location
    @location ||= current_tenant.locations.find(params[:location_id])
  end

  def table
    @table ||= location.tables.find(params[:id])
  end

  def tables
    @pagy, @tables = pagy(
      location.tables.includes(:qr_code).order(:position),
      items: 20
    )
  end
end
