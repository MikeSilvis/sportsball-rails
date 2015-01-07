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
                :recap,
                :time_remaining_summary

  def initialize(attrs)
    self.away_team              = Team.new(attrs, 'away')
    self.home_team              = Team.new(attrs, 'home')
    self.game_date              = attrs[:game_date]
    self.arena                  = attrs[:arena]
    self.score_summary          = attrs[:score_summary]
    self.score_detail           = attrs[:score_detail]
    self.state                  = attrs[:state]
    self.league                 = attrs[:league]
    self.game_id                = attrs[:game_id]
    self.time_remaining_summary = attrs[:time_remaining_summary]
  end

  def score_summary
    @score_summary.tap do |score_summary|
      score_summary[0][0] = time_remaining_summary.gsub('In Progress -', '').strip
    end
  end

  def recap
    Recap.find(league, game_id) if state == 'postgame'
  end

  def self.find(league, game_id)
    cache_key = "boxscore_cache_#{league}_#{game_id}"

    espn_boxscore = if Rails.cache.read(cache_key)
                      Rails.cache.read(cache_key)
                    else
                      ESPN::Boxscore.find(league, game_id)
                    end

    if espn_boxscore[:state] == 'postgame'
      Rails.cache.write(cache_key, espn_boxscore)
    end

    new(espn_boxscore)
  end
end
