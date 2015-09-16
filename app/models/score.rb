class Score < QueryBase
  include SportsBall
  attr_accessor :away_team,
                :home_team,
                :game_date,
                :away_score,
                :home_score,
                :state,
                :ended_in,
                :start_time,
                :time_remaining,
                :progress,
                :line,
                :id,
                :boxscore,
                :preview

  GAME_ORDER = {
    'pregame'     => 2,
    'in-progress' => 1,
    'postgame'    => 3
  }

  API_TO_STATE = {
    'pre' => 'pregame',
    'post' => 'postgame',
    'in-progress' => 'in-progress'
  }

  def initialize(event)
    ## TODO: Refactor into team
    self.home_team = Team.new({}).tap do |team|
      competitor = event.competitors.first

      team.name       = competitor.name
      team.record     = competitor.record.summary
      team.data_name  = competitor.id
      team.abbr       = competitor.abbreviation
      team.league     = event.league
      team.rank       = competitor.rank
    end

    ## TODO: Refactor into team
    self.away_team = Team.new({}).tap do |team|
      competitor = event.competitors.last

      team.name       = competitor.name
      team.record     = competitor.record.summary
      team.data_name  = competitor.id
      team.abbr       = competitor.abbreviation
      team.league     = event.league
      team.rank       = competitor.rank
    end

    self.game_date      = event.date
    self.start_time     = event.status.start_time
    self.state          = API_TO_STATE[event.status.state]
    self.ended_in       = event.status.final? ? event.status.detail : event.status.period
    self.league         = event.league
    self.home_score     = event.competitors.first.score
    self.away_score     = event.competitors.last.score
    self.progress       = event.status.period
    self.time_remaining = event.status.display_clock
    self.line           = event.line
    self.id             = event.gameid
    self.boxscore       = event.gameid
    self.preview        = event.gameid
  end

  def start_time
    @start_time.to_i
  end

  module ScoreFinder
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def all(league_id, date)
        Array(query_with_timeout(league_id, date).try(:events)).map do |score|
          Score.new(score)
        end
      end

      def query_with_timeout(league_id, date)
        begin
          Timeout.timeout(4) { SportsApi::Fetcher::Score.find(league_id, date) }
        rescue Timeout::Error
          []
        end
      end
    end
  end
  include ScoreFinder
end
