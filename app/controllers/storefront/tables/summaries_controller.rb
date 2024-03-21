class Storefront::Tables::SummariesController < Storefront::TablesController
  def show
    render locals: {
      table: @table,
      location: @location,
      organization: @organization,
      order: @order
    }
  end

  private

  def table
    @table ||= Table.find(params[:table_id])
  end
end
