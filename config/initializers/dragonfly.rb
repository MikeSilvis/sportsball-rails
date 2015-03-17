require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick
end

# Logger
Dragonfly.logger = Rails.logger
