require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    Realtime::Checker.delay.push_updates if Realtime::Channel.any?
  end

  every(2.minute, 'frequent.job')
end
