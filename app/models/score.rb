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
    val.to_s.gsub!('ET', 'EST')
    @start_time = Time.parse(val.to_s).utc
  rescue ArgumentError
    val
  end

  def start_time
    @start_time.to_i
  end

  concerning :UpdateFrequency do
    def check
      time = Time.now
      all = self.all
      puts 'still cached' while verify_similar(all)

      puts "ESPN took: #{Time.now - time} to update"
    end

    def verify_similar(all)
      all == self.all
    end
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
        end.select do |score|
          score.game_date == date
        end
      end

      def query_with_timeout(league_id, date)
        begin
          Timeout.timeout(3) { query_espn(league_id, date) }
        rescue Timeout::Error
          []
        end
      end

      def query_espn(league_id, date)
        cache_key = "score_cache_#{league_id}_#{date}"

        espn_scores = if Rails.cache.read(cache_key)
                        Rails.cache.read(cache_key)
                      else
                        ESPN.public_send("get_#{league_id}_scores_by_date", date).select do |score|
                          score[:game_date] == date
                        end
                      end

        if espn_scores.all? { |score| score[:state] == 'postgame' }
          Rails.cache.write(cache_key, espn_scores)
        end

        espn_scores
      end
      add_method_tracer :query_espn, 'Score/query_espn'
    end
  end
  include ScoreFinder

end
