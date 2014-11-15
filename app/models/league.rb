require 'timeout'

class League
  attr_accessor :name

  GAME_ORDER = {
    'pregame'     => 2,
    'in-progress' => 1,
    'postgame'    => 3
  }

  WEEK_LEAGUES = {
    'nfl' => {
      date: Date.new(2014, 9, 4)
    },
    'ncf' =>{
      date: Date.new(2014, 8, 28)
    }
  }

  def initialize(name)
    self.name = name
  end

  def scores(date = Date.today)
    hello = query_espn(date).map do |score|
      Score.new(score)
    end.sort_by do |score|
      [
        GAME_ORDER[score.state],
        #(score.start_time if score.start_time.is_a?(Time)),
        #(score.start_time.is_a?(Time) ? score.start_time : 1),
        -score.progress.to_i,
        score.time_remaining.to_s.gsub(':','.').to_f
      ]
    end#.reject do |score|
      #(score.start_time.to_s.to_date != date)
    #end
    #byebug
    hello
  end
  add_method_tracer :as_json, 'League/scores'

  def query_espn(date = Date.today)
    date = Date.today unless date
    Timeout::timeout(5) do
      if WEEK_LEAGUES[name]
        week = ((date - WEEK_LEAGUES[name][:date]).to_i / 7) + 1
        ESPN.public_send("get_#{name}_scores", date.year, week)
      else
        ESPN.public_send("get_#{name}_scores", date)
      end
    end rescue []
  end
  add_method_tracer :query_espn, 'League/query_espn'
end
