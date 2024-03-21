::Stripe.api_key = ENV.fetch('STRIPE_SECRET', nil)
::Stripe.max_network_retries = 2
