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

  def start_time=(val)
    @start_time = ActiveSupport::TimeZone['America/New_York'].parse(val.to_s).utc if val
  end

  def start_time
    @start_time.to_i
  end

  def content
    (league == 'nhl' ? nhl_preview[:content] : @content).gsub('\n', '').gsub(/\n/, '')
  end

  def headline
    league == 'nhl' ? nhl_preview[:headline] : @headline
  end

  def url
    league == 'nhl' ? nhl_preview[:url] : @url
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

  def nhl_preview
    @nhl_preview ||= Nhl::Preview.find_by(self.away_team.name, self.home_team.name, @start_time.in_time_zone('Central Time (US & Canada)').to_date)
  end
end
