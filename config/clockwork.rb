require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler { |job| RealtimeWorker.perform_async }

  every(20.seconds, 'frequent.job')
end
