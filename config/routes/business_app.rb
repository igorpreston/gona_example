if Rails.env.production?
  namespace :webhooks do
    resource :stripe_connect, only: %i[create], controller: 'stripe_connect'
    resource :stripe, only: %i[create], controller: 'stripe'
    resource :square, only: %i[create], controller: 'square'
    resource :clover, only: %i[create], controller: 'clover'
  end
end

devise_for :merchants, path: 'auth', controllers: {
  registrations: 'merchants/registrations',
  invitations: 'merchants/invitations',
  sessions: 'merchants/sessions',
  confirmations: 'merchants/confirmations',
  passwords: 'merchants/passwords'
}, path_names: {
  sign_in: 'login',
  sign_out: 'logout',
  sign_up: 'signup'
}

resources :merchants, only: %i[show]

resource :organization, only: %i[new create edit] do
  resource :general, only: %i[show edit update], module: 'organizations'
  resource :details, only: %i[show edit update], module: 'organizations'
  resource :billing, only: %i[show], module: 'organizations'
  resource :subscription, only: %i[show], module: 'organizations'
  resource :stripe_account_link, only: %i[show], module: 'organizations'

  resources :merchants, only: %i[index new create destroy], module: 'organizations'
  resources :integrations, only: %i[index new create destroy], module: 'organizations' do
    collection do
      resource :square_callback, only: %i[show], module: 'integrations'
      resource :clover_callback, only: %i[show], module: 'integrations'
    end
  end
end

resource :subscription, only: %i[show] do
  resource :checkout, only: %i[create], module: 'subscriptions'
end

resource :onboarding, only: %i[show] do
  resources :tasks, only: %i[show update], module: 'onboarding'
end

resources :locations do
  resource :menus, module: 'locations'
  resources :tables, except: %i[show], module: 'locations'
end

resources :qr_codes, except: %i[destroy]

resources :categories do
  resource :menus, only: %i[show], module: 'categories'
  resource :items, only: %i[show], module: 'categories'
  resources :category_items, only: %i[create destroy], module: 'categories'
end

resources :items

resources :menus do
  resource :schedule, only: %i[show], module: 'menus'
  resource :publish, only: %i[update], module: 'menus'
  resource :locations, only: %i[show], module: 'menus'
  resource :categories, only: %i[show create], module: 'menus'
  resources :menu_categories, module: 'menus' do
    resource :items, only: %i[show create], module: 'menu_categories'
    resources :menu_category_items, module: 'menu_categories' do
      resource :position, only: %i[update], module: 'menu_category_items'
    end
  end
end

resources :modifiers do
  resource :items, only: %i[show], module: 'modifiers'
  resources :options, except: :index, module: 'modifiers' do
    resource :position, only: %i[update], module: 'options'
  end
end

resources :payments, only: %i[index show] do
  resource :transition, only: %i[update], module: 'payments'
end

resources :orders, except: %i[new destroy edit] do
  resource :status, only: %i[update], module: 'orders'

  collection do
    resource :locations, only: %i[show], module: 'orders', as: 'order_locations'
    resource :count_total, only: %i[show], module: 'orders', as: 'order_count_total'
    resource :count_fulfilled, only: %i[show], module: 'orders', as: 'order_count_fulfilled'
    resource :count_fulfillment_time, only: %i[show], module: 'orders', as: 'order_count_fulfillment_time'
    resource :count_cancellations, only: %i[show], module: 'orders', as: 'order_count_cancellations'
  end
end

resources :feedbacks, only: %i[index show update] do
  collection do
    resource :locations, only: %i[show], module: 'feedbacks', as: 'feedback_locations'
    resource :count_totals, only: %i[show], module: 'feedbacks', as: 'feedback_count_total'
    resource :count_replies, only: %i[show], module: 'feedbacks', as: 'feedback_count_replies'
  end
end

resource :suggestions, only: %i[show create]

resource :dashboard, only: %i[show] do
  collection do
    resource :onboardings, only: %i[show], module: 'dashboard' do
      resources :tasks, only: %i[update], module: 'onboardings' do
        member do
          resource :complete, only: %i[update], module: 'tasks'
          resource :incomplete, only: %i[update], module: 'tasks'
        end
      end
    end
  end
end

# root 'dashboard#show'
root 'orders#index'
