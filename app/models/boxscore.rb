class Boxscore
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
                :game_id

  def initialize(attrs)
    self.game_date      = attrs[:game_date]
    self.away_team      = Team.new(attrs, 'away')
    self.home_team      = Team.new(attrs, 'home')
    self.arena          = attrs[:arena]
    self.score_summary  = attrs[:score_summary]
    self.score_detail   = attrs[:score_detail]
    self.state          = attrs[:state]
    self.league         = attrs[:league]
    self.game_id        = attrs[:game_id]
  end

  def as_json(*)
    {
      game_date: game_date,
      home_team: home_team,
      away_team: away_team,
      arena: arena,
      score_summary: score_summary,
      score_detail: score_detail,
      recap: recap
    }.compact
  end
  add_method_tracer :as_json, 'Boxscore/as_json'

  def recap
    if state == 'postgame'
      Recap.find(league, game_id)
    end
  end

  def self.find(league, game_id)
    new(ESPN::Boxscore.find(league, game_id))
  end
end
