Geocoder.configure(
  cache: Redis.new,
  timeout: 3,
  lookup: :google,
  language: :en,
  use_https: true,
  api_key: ENV.fetch('GOOGLE_MAPS_API_KEY', nil),
  units: :km,
  always_raise: :all
  # Cache configuration
  # cache_options: {
  #   expiration: 2.days,
  #   prefix: 'geocoder:'
  # }

  # or if we use Redis
  # cache: Redis.new
)
