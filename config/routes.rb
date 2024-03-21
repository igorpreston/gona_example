require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  if Rails.env.development?
    namespace :webhooks do
      resource :stripe_connect, only: %i[create], controller: 'stripe_connect'
      resource :stripe, only: %i[create], controller: 'stripe'
      resource :square, only: %i[create], controller: 'square'
      resource :clover, only: %i[create], controller: 'clover'
    end
  end

  direct :website do
    ENV.fetch('GONA_WEBSITE', 'https://www.gona.app')
  end

  direct :terms do
    ENV.fetch('GONA_TERMS', nil)
  end

  direct :privacy do
    ENV.fetch('GONA_PRIVACY', nil)
  end

  constraints subdomain: 'business' do
    draw :business_app
  end

  if Rails.env.development?
    draw :storefront_app
  else
    constraints subdomain: 'order' do
      draw :storefront_app
    end
  end
end
