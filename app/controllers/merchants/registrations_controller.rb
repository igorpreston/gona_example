class Merchants::RegistrationsController < Devise::RegistrationsController
  layout 'application', only: %i[edit]
  layout 'devise_merchant', except: %i[edit]

  private

  def after_sign_up_path_for(resource)
    if resource.is_a?(Merchant)
      new_organization_path
    else
      super
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
