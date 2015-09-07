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
                :game_info,
                :photo

  def initialize(boxscore)
    ## TODO: Refactor into team
    self.home_team = Team.new({}).tap do |team|
      competitor = boxscore.event.competitors.first

      team.name       = competitor.name
      team.record     = competitor.record.summary
      team.data_name  = competitor.id
      team.abbr       = competitor.abbreviation
      team.league     = boxscore.event.league
      team.rank       = competitor.rank
    end

    ## TODO: Refactor into team
    self.away_team = Team.new({}).tap do |team|
      competitor = boxscore.event.competitors.last

      team.name       = competitor.name
      team.record     = competitor.record.summary
      team.data_name  = competitor.id
      team.abbr       = competitor.abbreviation
      team.league     = boxscore.event.league
      team.rank       = competitor.rank
    end

    self.league     = boxscore.event.league
    self.game_id    = boxscore.event.gameid
    self.start_time = boxscore.event.status.start_time
    self.headline   = boxscore.event.headline.title
    self.content    = boxscore.event.headline.content
    self.url        = boxscore.event.headline.url
    self.photo      = boxscore.event.headline.photo

    self.channel   = boxscore.event.channel
    self.location  = boxscore.location
  end

  def home_team_schedule
    @home_team_schedule ||= Schedule.find(self.league, self.home_team.data_name) if self.content.present?
  end

  def away_team_schedule
    @away_team_schedule ||= Schedule.find(self.league, self.away_team.data_name) if self.content.present?
  end

  def start_time
    @start_time.to_i
  end

  def self.find(league, game_id)
    new(SportsApi::Fetcher::Boxscore.find(league, game_id))
  end

  def headline=(headline)
    @headline = headline ? headline : preview[:headline]
  end

  def content=(content)
    @content = content ? content : preview[:content]
  end

  def photo=(photo)
    @photo = photo ? photo : preview[:photo]
  end

  def preview
    @preview ||= ESPN::Preview.find(league, game_id)
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
