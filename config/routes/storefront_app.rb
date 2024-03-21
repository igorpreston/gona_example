resources :menu_category_items, only: %i[new], module: 'storefront'
resources :qr_codes, only: %i[show], module: 'storefront'
resources :locations, only: %i[show], module: 'storefront' do
  resource :details, only: %i[show], module: 'locations'
  resources :menus, only: %i[show], module: 'locations'
  resources :orders, only: %i[show update], module: 'locations' do
    resources :order_items, only: %i[destroy], module: 'orders'
  end
end
resources :tables, only: %i[show], module: 'storefront'
resources :orders, module: 'storefront' do
  resources :order_users, only: %i[show], module: 'orders' do
    resource :feedback, only: %i[show create], module: 'order_users'
    resource :receipt, only: %i[show], module: 'order_users'
  end

  resource :checkout, only: %i[show create], module: 'orders' do
    resources :order_items, only: %i[index destroy], module: 'checkouts'

    resource :processor, only: %i[show], module: 'checkouts'
    resource :order_user, only: %i[create show], module: 'checkouts'
    resource :stripe_payment, only: %i[show], module: 'checkouts'
  end

  # In development part...
  #############################################################
  #############################################################
  #############################################################
  #############################################################
  #############################################################
  #############################################################
  #############################################################

  resource :equal_split, only: %i[show update], module: 'orders'

  #############################################################
  #############################################################
  #############################################################
  #############################################################
  #############################################################
  #############################################################
  #############################################################
  resource :summary, only: %i[show], module: 'orders'
  resources :payments, only: %i[show], module: 'orders'

  resources :order_items, only: %i[new edit update create destroy], module: 'orders'
end

root to: 'storefront/front_page#show', as: :storefront_root
