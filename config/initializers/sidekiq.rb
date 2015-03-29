Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISTOGO_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISTOGO_URL'] }
end

require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["auxotic", "auxotic"]
end
