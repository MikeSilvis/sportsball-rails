require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    RealtimePush.perform_async if Realtime::Channel.any?
  end

  every(1.minute, 'frequent.job')
end
