class Recap
  attr_accessor :league,
                :game_id,
                :content,
                :headline

  def initialize(attrs)
    self.league   = attrs[:league]
    self.game_id  = attrs[:game_id]
    self.content  = attrs[:content]
    self.headline = attrs[:headline]
  end

  def as_json(*)
    {
      content: content,
      headline: headline
    }.compact
  end

  def self.find(league, game_id)
    new(ESPN::Recap.find(league, game_id))
  end
end
