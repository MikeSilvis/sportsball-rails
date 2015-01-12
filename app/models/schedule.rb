class Schedule < QueryBase
  attr_accessor :games

  def initialize(attrs)
    self.games = attrs
  end

  def self.find(league, team_data_name)
    new(ESPN::Schedule.find(league, team_data_name))
  end
end
