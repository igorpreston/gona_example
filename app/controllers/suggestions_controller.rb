class SuggestionsController < ApplicationController
  def show
    suggestion = current_merchant.suggestions.new

    render locals: { suggestion: }
  end

  def create
    suggestion = current_merchant.suggestions.new(
      description: params[:description],
      referer: request.referer,
      data: {
        user_agent: request.user_agent,
        ip: request.remote_ip
      }
    )

    if suggestion.save
      respond_to do |format|
        format.turbo_stream do
          render locals: { suggestion: }
        end
      end
    else
      render :new
    end
  end
end
