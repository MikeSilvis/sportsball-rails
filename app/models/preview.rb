class Preview < QueryBase
  attr_accessor :content,
                :headline,
                :start_time,
                :location,
                :home_team,
                :away_team,
                :channel,
                :url,
                :series,
                :game_id,
                :league,
                :away_team_schedule,
                :home_team_schedule,
                :game_info

  def initialize(attrs)
    self.away_team  = Team.new(attrs, 'away')
    self.home_team  = Team.new(attrs, 'home')
    self.content    = attrs[:content]
    self.headline   = attrs[:headline]
    self.start_time = attrs[:start_time]
    self.channel    = attrs[:channel]
    self.location   = attrs[:location]
    self.url        = attrs[:url]
    self.series     = attrs[:series]
    self.game_id    = attrs[:game_id]
    self.league     = attrs[:league]
  end

  def home_team_schedule
    @home_team_schedule ||= Schedule.find(self.league, self.home_team.data_name)
  end

  def away_team_schedule
    @away_team_schedule ||= Schedule.find(self.league, self.away_team.data_name)
  end

  def start_time
    @start_time.to_i
  end

  def content
    @content.gsub(/\n/, '')
  end

  def self.find(league, game_id)
    new(ESPN::Preview.find(league, game_id))
  end

  def game_info
    @game_info ||= GameInfo.new(
      {
        start_time: start_time,
        channel: channel,
        location: location
      }
    )
  end
end
