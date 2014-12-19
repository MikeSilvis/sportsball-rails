class Recap
  attr_accessor :league,
                :game_id,
                :content

  def initialize(attrs)
    self.league  = attrs[:league]
    self.game_id = attrs[:game_id]
    self.content = attrs[:content]
  end

  def as_json(*)
    {
      content: content
    }.compact
  end

  def self.find(league, game_id)
    new(ESPN::Recap.find(league, game_id))
  end
end
