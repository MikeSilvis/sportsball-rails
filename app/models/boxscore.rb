class Boxscore < QueryBase
  attr_accessor :game_date,
                :arena,
                :home_team,
                :home_team_name,
                :home_team_score,
                :away_team,
                :away_team_name,
                :away_team_score,
                :score_summary,
                :score_detail,
                :state,
                :league,
                :game_id,
                :recap

  def initialize(attrs)
    self.away_team      = Team.new(attrs, 'away')
    self.home_team      = Team.new(attrs, 'home')
    self.game_date      = attrs[:game_date]
    self.arena          = attrs[:arena]
    self.score_summary  = attrs[:score_summary]
    self.score_detail   = attrs[:score_detail]
    self.state          = attrs[:state]
    self.league         = attrs[:league]
    self.game_id        = attrs[:game_id]
  end

  def recap
    if state == 'postgame'
      Recap.find(league, game_id)
    end
  end

  def self.find(league, game_id)
    new(ESPN::Boxscore.find(league, game_id))
  end
end
