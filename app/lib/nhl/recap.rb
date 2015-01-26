class Nhl::Recap
  attr_accessor :game_id, :data, :league

  def initialize(game_id)
    self.game_id  = game_id
    self.league   = 'nhl'
    self.data     = {}
  end

  def self.find(game_id)
    new(game_id).get_data_with_cache
  end

  def get_data_with_cache
    Rails.cache.fetch("cache_recap_#{game_id}") do
      get_data
    end
  end

  private

  def get_data
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
    @url ||= "http://www.nhl.com/gamecenter/en/recap?id=#{game_id}"
  end
end
