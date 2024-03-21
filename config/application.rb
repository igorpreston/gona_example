require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gona
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.helper false
      g.test_framework :rspec
      g.integration_tool nil
      g.system_tests nil
    end

    # Default and available currencies
    config.currency = 'CAD'
    config.currencies = %w[CAD USD].freeze

    # Default and available countries
    config.country = 'CA'
    config.countries = %w[CA US].freeze

    # Default application fee rate
    config.application_fee_rate = 0.03

    # Default tax rate
    config.tax_rate = 0.13

    # Default job queue adapter
    config.active_job.queue_adapter = :sidekiq

    # Default rails app
    config.application_name = Rails.application.class.module_parent_name

    # Fonta Awesome default style
    config.fa_style = 'fa-regular'

    # Action Mailer configuration
    config.action_mailer.default_url_options = {
      protocol: ENV.fetch('PROTOCOL', 'https'),
      host: ENV.fetch('HOST', 'localhost:3000')
    }
  end
end
