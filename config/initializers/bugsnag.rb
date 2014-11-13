if Rails.env.production?
  Bugsnag.configure do |config|
    config.api_key = "4dca41d985a27f528cfb421636916231"
  end
end
