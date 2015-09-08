class Boxscore < QueryBase
  attr_accessor :game_date,
                :arena,
                :home_team,
                :home_team_score,
                :away_team,
                :away_team_score,
                :score_summary,
                :score_detail,
                :state,
                :league,
                :game_id,
                :recap,
                :time_remaining_summary,
                :channel,
                :location,
                :start_time,
                :game_info,
                :game_stats

  FIXED_GAME_STAT_HEADERS = {
    'FGM-A' => 'Field Goals',
    '3PM-A' => '3 Pointers',
    'FTM-A' => 'Free Throws',
    'REB'   => 'Rebounds',
    'AST'   => 'Assists',
    'STL'   => 'Steals',
    'BLK'   => 'Blocks',
    'TO'    => 'Turn Overs',
    'PTS'   => 'Points',
    'OREB'  => 'Offensive',
    'DREB'  => 'Deffensive'
  }

  def initialize(boxscore)
    ## TODO: Refactor into team
    self.home_team = Team.new({}).tap do |team|
      competitor = boxscore.event.competitors.first

      team.name       = competitor.name
      team.record     = competitor.record.summary
      team.data_name  = competitor.id
      team.abbr       = competitor.abbreviation
      team.league     = boxscore.event.league
      team.rank       = competitor.rank
    end

    ## TODO: Refactor into team
    self.away_team = Team.new({}).tap do |team|
      competitor = boxscore.event.competitors.last

      team.name       = competitor.name
      team.record     = competitor.record.summary
      team.data_name  = competitor.id
      team.abbr       = competitor.abbreviation
      team.league     = boxscore.event.league
      team.rank       = competitor.rank
    end

    self.game_date              = boxscore.event.date
    self.score_summary          = boxscore.event.score
    self.score_detail           = boxscore.score_details
    self.state                  = boxscore.event.status.state
    self.league                 = boxscore.event.league
    self.game_id                = boxscore.event.gameid
    self.time_remaining_summary = boxscore.event.status.display_clock
    self.start_time             = boxscore.event.status.start_time
    self.recap                  = boxscore.event.headline
  end

  def start_time
    @start_time.to_i
  end

  def score_detail=(score_detail)
    @score_detail = score_detail.map do |detail|
      {
        detail.headline => detail.contents.map do |content|
          [
            content.competitor.abbreviation,
            content.time,
            content.detail
          ]
        end
      }
    end
  end

  def recap=(recap)
    @recap = Recap.new(recap)
  end

  def score_summary
    @score_summary.tap do |score_summary|
      score_summary[0][0] = time_remaining_summary.gsub('In Progress -', '').strip
    end
  end

  def game_stats
    return nil unless @game_stats

    @game_stats.tap do |stats|
      stats[:header] = stats[:header].map do |header|
                         FIXED_GAME_STAT_HEADERS[header] || header
                       end
    end
  end

  def game_info
    @game_info ||= GameInfo.new(
      {
        start_time: start_time,
        channel: channel,
        location: location
      }
    )
  end

  def self.find(league, game_id)
    new(SportsApi::Fetcher::Boxscore.find(league, game_id))
  end
end
