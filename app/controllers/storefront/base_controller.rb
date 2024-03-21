class Storefront::BaseController < ActionController::Base
  layout 'storefront'

  before_action :store_user_location!, if: :storable_location?
  before_action :current_cart
  before_action :current_order
  before_action :current_order_user

  def current_cart
    @current_cart ||= Storefront::Cart.find_or_create_by!(id: session[:cart_id]).tap do |cart|
      session[:cart_id] = cart.id unless session[:cart_id].present?
    end
  end

  def current_order
    # we create a new order in locations_controller.rb
    @current_order ||= current_cart.orders.find_by(id: session[:order_id])
  end

  def current_order_user
    # we create a new order_user in locations_controller.rb
    @current_order_user ||= current_order&.order_users&.find_by(id: session[:order_user_id])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path || super
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
