class Organizations::GeneralsController < ApplicationController
  def show
    render locals: { organization: }
  end

  def edit
    render layout: false, locals: { organization: }
  end

  def update
    if organization.update(organization_params)
      respond_to do |format|
        format.turbo_stream do
          render locals: { organization: }
        end
      end
    else
      render :show, locals: { organization: }
    end
  end

  private

  def organization
    @organization ||= current_tenant
  end

  def organization_params
    params.require(:organization).permit(
      :name,
      :nickname,
      :description,
      :logo,
      :cover_image
    )
  end
end
