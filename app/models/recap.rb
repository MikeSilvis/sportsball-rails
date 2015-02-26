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
    @content.to_s.gsub('\n', '').gsub(/\n/, '')
  end

  def self.find(league, game_id, away_team_name, home_team_name, game_date)
    data = if league == 'nhl'
             Nhl::Recap.find_by(away_team_name, home_team_name, game_date)
           else
             ESPN::Recap.find(league, game_id)
           end

    new(data).tap do |recap|
      recap.game_id = game_id
    end
  end

  def photo
    "#{photos[:photos].first}&h=400"
  end

  private

  def photos
    @photos ||= ESPN::Photo.find(league, game_id)
  end
end
