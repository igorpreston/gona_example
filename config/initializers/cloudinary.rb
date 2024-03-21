Cloudinary.config do |config|
  config.cloud_name = ENV.fetch('CLOUDINARY_NAME', nil)
  config.api_key = ENV.fetch('CLOUDINARY_API_KEY', nil)
  config.api_secret = ENV.fetch('CLOUDINARY_SECRET', nil)
  config.secure = true
end
