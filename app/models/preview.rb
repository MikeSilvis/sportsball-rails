class Preview < QueryBase
  attr_accessor :content,
                :headline,
                :start_time,
                :location,
                :home_team,
                :away_team,
                :channel

  def initialize(attrs)
    self.away_team  = Team.new(attrs, 'away')
    self.home_team  = Team.new(attrs, 'home')
    self.content    = attrs[:content]
    self.headline   = attrs[:headline]
    self.start_time = attrs[:start_time]
    self.channel    = attrs[:channel]
    self.location   = attrs[:location]
  end

  def self.find(league, game_id)
    new(ESPN::Preview.find(league, game_id))
  end
end
