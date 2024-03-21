class Modifiers::Options::PositionsController < ApplicationController
  def update
    head :ok if options.insert_at(params[:position].to_i)
  end

  private

  def options
    @options ||= Option.find(params[:option_id])
  end
end
