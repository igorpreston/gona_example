class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ActiveStorage::SetCurrent

  set_current_tenant_through_filter

  before_action :authenticate_merchant!
  before_action :set_tenant, if: :current_merchant
  before_action :set_turbo_frame_request
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_tenant
    set_current_tenant(current_merchant.organization)
  end

  def set_turbo_frame_request
    @turbo_frame_request = turbo_frame_request?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[
        first_name
        last_name
        email
        avatar
        password
        password_confirmation
        current_password
      ]
    )
    devise_parameter_sanitizer.permit(
      :accept_invitation,
      keys: %i[
        first_name
        last_name
        password
      ]
    )
  end
end
