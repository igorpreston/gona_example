# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    if Rails.env.development?
      policy.script_src :self, :https, :unsafe_inline, :unsafe_eval, :blob, 'https://maps.googleapis.com',
                        'https://js.stripe.com', 'https://api.mapbox.com', 'https://events.mapbox.com', 'https://sandbox.web.squarecdn.com/', "wss://#{ViteRuby.config.host}", 'https://pci-connect.squareupsandbox.com/payments/mtx/v2'

      policy.style_src :self, ViteRuby.config.origin, 'https://rsms.me/inter/inter.css',
                       'https://sandbox.web.squarecdn.com/1.53.0/card-wrapper.css', :unsafe_inline
      policy.connect_src :self, "wss://#{ViteRuby.config.host}", 'https://maps.googleapis.com',
                         'https://api.mapbox.com', 'https://sandbox.web.squarecdn.com/', 'https://events.mapbox.com', 'https://pci-connect.squareupsandbox.com/payments/mtx/v2'
    end
  end
end
