class Standing
  attr_accessor :teams

  def initialize(attrs)
    self.teams = attrs.map do |team|
      Team.new(team)
    end
  end

  def self.find(league)
    new(ESPN::Standings.find(league))
  end
end
