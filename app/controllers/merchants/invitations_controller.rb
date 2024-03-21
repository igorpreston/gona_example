class Merchants::InvitationsController < Devise::InvitationsController
  layout 'devise_merchant'

  def update
    if resource.is_a?(User)
      redirect_to root_path
    else
      super
    end
  end
end
