class Nhl::Info
  attr_accessor :game_id, :data, :league

  def initialize(game_id)
    self.game_id  = game_id
    self.league   = 'nhl'
    self.data     = {}
  end

  def self.find_by(away_team_name, home_team_name, game_date)
    new(Nhl::GameId.find(away_team_name, home_team_name, game_date)).get_data_with_cache
  end

  def self.find(game_id)
    new(game_id).get_data_with_cache
  end

  def get_data_with_cache
    recap = if Rails.cache.read(cache_key)
              Rails.cache.read(cache_key)
            else
              get_data
            end

    Rails.cache.write(cache_key, recap) unless get_data[:content].blank?

    recap
  end

  private

  def get_data
    return {} unless markup.at_css('.contentPad.article h1')

    data[:headline] = markup.at_css('.contentPad.article h1').content
    data[:content]  = markup.css('.contentPad.article p').map(&:content).join('\n')
    data[:url]      = url
    data[:game_id]  = self.game_id
    data[:league]   = self.league

    return data
  end

  def markup
    @markup ||= Nokogiri::HTML(client.body)
  end

  def client
    @client ||= Faraday.get(url)
  end

  def url
    raise "Must be implemented by super class"
  end

  def cache_key
    raise "must be implemtend by super class"
  end
end
