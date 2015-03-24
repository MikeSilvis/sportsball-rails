require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler { |job| RealtimeWorker.perform_async }

  every(2.minute, 'frequent.job')
end
