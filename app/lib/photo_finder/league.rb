class PhotoFinder::League
  attr_accessor :league

  def initialize(league)
    self.league = league
  end

  def get_photos(&block)
    teams.map do |team|
      yield(PhotoFinder::Team.new(team, league))
    end
  end

  def teams
    @teams ||= ESPN::Team.find(league).values.flatten
  end
end
