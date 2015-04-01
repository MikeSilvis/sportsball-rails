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

  def initialize(attrs)
    self.game_date      = attrs[:game_date]
    self.home_team      = Team.new(attrs, 'home')
    self.away_team      = Team.new(attrs, 'away')
    self.start_time     = attrs[:start_time]
    self.state          = attrs[:state]
    self.ended_in       = attrs[:ended_in]
    self.league         = attrs[:league]
    self.away_score     = attrs[:away_score]
    self.home_score     = attrs[:home_score]
    self.progress       = attrs[:progress]
    self.time_remaining = attrs[:time_remaining]
    self.line           = attrs[:line]
    self.id             = attrs[:id]
    self.boxscore       = attrs[:boxscore]
    self.preview        = attrs[:preview]
  end

  def start_time=(val)
    @start_time = ActiveSupport::TimeZone['America/New_York'].parse(val.to_s).utc if val
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
        query_with_timeout(league_id, date).map do |score|
          Score.new(score)
        end.sort_by do |score|
          [
            GAME_ORDER[score.state],
            score.start_time.to_i,
            -score.progress.to_i,
            score.time_remaining.to_s.gsub(':', '.').to_f
          ]
        end
      end

      def query_with_timeout(league_id, date)
        begin
          Timeout.timeout(4) { ESPN::Score.find(league_id, date) }
        rescue Timeout::Error
          []
        end
      end
    end
  end
  include ScoreFinder
end
