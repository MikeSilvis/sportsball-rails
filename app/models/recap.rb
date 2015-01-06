class Recap < QueryBase
  attr_accessor :league,
                :game_id,
                :content,
                :headline,
                :url,
                :photo

  def initialize(attrs)
    self.league   = attrs[:league]
    self.game_id  = attrs[:game_id]
    self.content  = attrs[:content]
    self.headline = attrs[:headline]
    self.url      = attrs[:url]
  end

  def content
    @content.gsub(/\n/, '')
  end

  def url
    "http://m.espn.go.com/#{league}/gamecast?gameId=#{game_id}&appsrc=sc"
  end

  def self.find(league, game_id)
    new(ESPN::Recap.find(league, game_id))
  end

  def photo
    "#{photos[:photos].first}&h=400"
  end

  private

  def photos
    @photos ||= ESPN::Photo.find(league, game_id)
  end
end
