require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    return unless Realtime::Channel.any?

    RealtimeWorker.perform_async
  end

  every(2.minute, 'frequent.job')
end
