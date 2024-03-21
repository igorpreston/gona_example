# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Sendgrid setup
ActionMailer::Base.smtp_settings = {
  user_name: ENV.fetch('SMTP_LOGIN', nil),
  password: ENV.fetch('SMTP_PASSWORD', nil),
  domain: ENV.fetch('SMTP_DOMAIN', nil),
  address: ENV.fetch('SMTP_SERVER', nil),
  port: ENV.fetch('SMTP_PORT', nil),
  authentication: :plain,
  enable_starttls_auto: true
}

ActionMailer::Base.delivery_method = :smtp
