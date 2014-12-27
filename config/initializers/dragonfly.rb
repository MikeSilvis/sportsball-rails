require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "47c6e7c13c4b3c73886d63c2cacef8a398e2d2fa58745eccfa7ae2d2c953c114"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end