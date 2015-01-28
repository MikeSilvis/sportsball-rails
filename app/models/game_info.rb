class GameInfo < QueryBase
  attr_accessor :odds,
                :start_time,
                :channel,
                :location

  def initialize(attrs)
    self.odds       = attrs[:odds]
    self.start_time = attrs[:start_time]
    self.channel    = attrs[:channel]
    self.location   = attrs[:location]
  end
end
