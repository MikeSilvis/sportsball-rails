class League
  attr_accessor :name

  SPECIAL_LEAGUES = {
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
    query_espn(date).map do |score|
      Score.new(score)
    end
  end
  add_method_tracer :as_json, 'League/scores'

  def query_espn(date = Date.today)
    date = Date.today unless date

    if SPECIAL_LEAGUES[name]
      week = ((date - SPECIAL_LEAGUES[name][:date]).to_i / 7) + 1
      ESPN.public_send("get_#{name}_scores", date.year, week)
    else
      ESPN.public_send("get_#{name}_scores", date)
    end
  end
  add_method_tracer :as_json, 'League/query_espn'
end
