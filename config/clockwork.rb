require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    return unless Realtime::Channel.any?

    Realtime::Checker.delay.push_updates
  end

  every(2.minute, 'frequent.job')
end
