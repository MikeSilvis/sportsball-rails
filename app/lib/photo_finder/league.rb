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

  private

  def markup_for(team)
    ESPN.get("#{league}/team/photos/_/name/#{team}")
  end

  def teams
    @teams ||= ESPN.get_teams_in(league).values.flatten
  end
end
