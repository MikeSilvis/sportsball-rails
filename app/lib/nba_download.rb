class NBADownload
  URL = 'http://www.foxsports.com/nba/teams'
  attr_accessor :teams

  def save_images
    espn_teams.each do |team|
      team_attrs = {
        team: team[:data_name],
        team_name: team[:name],
      }
      Team.new(team_attrs).download_logo(images[team[:name]])
    end
  end

  def images
    team_markup.inject({}) do |hash, t|
      byebug if get_team_name(t) == 'class'
      hash[get_team_name(t)] = get_team_logo(t)
      hash
    end
  end

  def get_team_name(t)
    t.css('.team-index-block-item-text-head-lineOne, .team-index-block-item-text-head-lineTwo').map(&:content).join(' ')
  end

  def get_team_logo(t)
    t.at_css('img').attributes['src'].value.gsub('100.100', '200.200')
  end

  def team_markup
    @team_markup ||= markup.css('.team-index-block-item')
  end

  def markup
    @markup ||= Nokogiri::HTML(Faraday.get(URL).body)
  end

  def espn_teams
    @espn_teams ||= ESPN.get_teams_in('nba').values.flatten
  end
end
