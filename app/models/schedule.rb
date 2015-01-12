class Schedule < QueryBase
  attr_accessor :games,
                :league,
                :team_data_name

  def initialize(attrs)
    self.league         = attrs[:league]
    self.team_data_name = attrs[:team_name]

    self.games = attrs[:games].map do |game|
      game.tap do |gm|
        gm[:opponent_logo] = Team.logo(self.league, gm[:opponent])
      end
    end
  end

  def self.find(league, team_data_name)
    new(ESPN::Schedule.find(league, team_data_name))
  end
end
