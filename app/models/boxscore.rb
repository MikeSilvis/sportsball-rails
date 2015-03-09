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
    self.channel                = attrs[:channel]
    self.location               = attrs[:location]
    self.start_time             = attrs[:start_time]
    self.game_stats             = attrs[:game_stats]
  end

  def start_time
    @start_time.to_i
  end

  def score_summary
    @score_summary.tap do |score_summary|
      score_summary[0][0] = time_remaining_summary.gsub('In Progress -', '').strip
    end
  end

  def recap
    return nil unless state =='postgame'

    Recap.find(league, game_id, self.away_team.name, self.home_team.name, self.game_date).tap do |recap|
      return nil if recap.headline.to_s.match(/No recap/)
    end
  end

  def start_time=(val)
    @start_time = ActiveSupport::TimeZone['America/New_York'].parse(val.to_s).utc if val
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
    new(ESPN::Boxscore.find(league, game_id))
  end
end
