class Nhl::GameId
  SEASON = 20142015
  attr_accessor :home_team,
                :away_team,
                :date

  def initialize(away_team, home_team, date)
    self.home_team = home_team.titleize
    self.away_team = away_team.titleize
    self.date = date
  end

  def self.find(away_team, home_team, date)
    new(away_team, home_team, date).game_id
  end

  def game_id
    markup.css('tbody tr').each do |row|
      if (row.css('.teamName').map(&:content) & [away_team, home_team]).empty?
        query = Addressable::URI::parse(row.css('.skedLinks a').first.attributes['href'].value).query
        return CGI::parse(query)['id'].first.to_i
      end
    end
  end

  private

  def date_string
    date.strftime('%m/%d/%Y')
  end

  def markup
    @markup ||= Nokogiri::HTML(client.body)
  end

  def client
    @client ||= Faraday.get("http://www.nhl.com/ice/schedulebyday.htm?date=#{date_string}&season=#{SEASON}")
  end
end
