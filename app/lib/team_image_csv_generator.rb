class TeamImageCsvGenerator
  LEAGUES = %w[nhl nfl]
  attr_accessor :league

  def initialize(league)
    self.league = league
  end

  def self.generate_for_all_teams
    LEAGUES.each do |league|
      TeamImageCsvGenerator.new(league).generate
    end
  end

  def generate
    CSV.open("nhl.csv", "wb") do |csv|
      csv << ['League', 'Team Name', 'File URL']
      teams.each do |team|
        csv << [league, team[:name], '']
      end
    end
  end

  def teams
    @teams ||= ESPN.get_teams_in(league).values.flatten
  end
end
