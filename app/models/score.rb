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

  WEEK_LEAGUES = %w[nfl ncf]

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

  def as_json(*)
    {
      game_date: game_date,
      home_team: home_team,
      away_team: away_team,
      start_time: start_time,
      state: state,
      ended_in: ended_in,
      league: league,
      away_score: away_score,
      home_score: home_score,
      progress: progress,
      time_remaining: time_remaining,
      line: line,
      boxscore: boxscore,
      preview: preview
    }.compact
  end
  add_method_tracer :as_json, 'Score/as_json'

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

  def self.all(league_id, date)
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

  def self.query_with_timeout(league_id, date)
    begin
      Timeout.timeout(3) { query_espn(league_id, date) }
    rescue Timeout::Error
      []
    end
  end

  def self.query_espn(league_id, date)
    if WEEK_LEAGUES.include?(league_id)
      week = ((date - League.new(league_id).schedule.first).to_i / 7) + 1
      ESPN.public_send("get_#{league_id}_scores", date.year, week)
    else
      ESPN.public_send("get_#{league_id}_scores", date)
    end
  end
  add_method_tracer :query_espn, 'Score/query_espn'

end
