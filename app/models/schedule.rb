class Schedule < QueryBase
  attr_accessor :games,
                :league,
                :team_data_name

  def initialize(attrs)
    self.league         = attrs[:league]
    self.team_data_name = attrs[:team_name]

    self.games = attrs[:games].map do |game|
      {
        opponent: {
          logo: (Team.logo(self.league, game[:opponent]) rescue byebug),
          name: game[:opponent_name],
          data_name: game[:opponent]
        },
        date: game[:date],
        over: game[:over],
        result: game[:result],
        win: game[:win],
        is_away: game[:is_away],
        start_time: game[:time].to_i
      }.compact
    end
  end

  def self.find(league, team_data_name)
    new(ESPN::Schedule::Team.find(league, team_data_name))
  end
end
