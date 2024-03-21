class Organizations::IntegrationsController < ApplicationController
  def index
    render locals: { integrations: }
  end

  def destroy
    if current_tenant.integrations.find(params[:id]).destroy
      redirect_to organization_integrations_path, notice: 'Integration was successfully destroyed.'
    else
      redirect_to organization_integrations_path, alert: 'Integration could not be destroyed.'
    end
  end

  private

  def integrations
    @pagy, @integrations = pagy(current_tenant.integrations.order(created_at: :desc), items: 10)
  end
end
