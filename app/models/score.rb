class Score
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
                :progress

  GAME_ORDER = {
    'pregame'     => 2,
    'in-progress' => 1,
    'postgame'    => 3
  }

  def initialize(attrs)
    self.away_team      = Team.new(attrs, 'away')
    self.home_team      = Team.new(attrs, 'home')
    self.state          = attrs[:state]
    self.ended_in       = attrs[:ended_in]
    self.league         = attrs[:league]
    self.start_time     = attrs[:start_time]
    self.game_date      = attrs[:game_date]
    self.away_score     = attrs[:away_score]
    self.home_score     = attrs[:home_score]
    self.time_remaining = attrs[:time_remaining]
    self.progress       = attrs[:progress]
  end

  def start_time=(val)
    val.to_s.gsub!('ET', 'EST')
    @start_time = if val
                    Time.parse(val).utc
                  end
  end

  def as_json(attrs)
    {
      game_date: game_date,
      home_team: home_team.as_json,
      away_team: away_team.as_json,
      start_time: start_time.to_i,
      state: state,
      start_time: start_time,
      ended_in: ended_in,
      league: league,
      away_score: away_score,
      home_score: home_score,
      progress: progress
    }
  end
  add_method_tracer :as_json, 'Score/as_json'

  concerning :UpdateFrequency do
    def check
      time = Time.now
      all = self.all
      while verify_similar(all)
        puts 'still cached'
      end

      puts "ESPN took: #{Time.now - time} to update"
    end

    def verify_similar(all)
      all == self.all
    end
  end
end
