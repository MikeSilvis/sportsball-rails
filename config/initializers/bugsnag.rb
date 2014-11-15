require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = "4dca41d985a27f528cfb421636916231"
  config.notify_release_stages = ["production"]
end
