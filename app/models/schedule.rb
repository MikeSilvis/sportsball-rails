class Schedule
  attr_accessor :games

  def initialize(attrs)
    self.games = attrs[:games]
  end

  def as_json(*)
    {
      games: games
    }.compact
  end
  add_method_tracer :as_json, 'Schedule/as_json'

  def self.find(league, team_data_name)
    new(ESPN::Schedule.find(league, team_data_name))
  end
end
