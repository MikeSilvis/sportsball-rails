class Recap < QueryBase
  attr_accessor :league,
                :game_id,
                :content,
                :headline,
                :url,
                :photo

  def initialize(recap)
    self.content  = recap.content
    self.headline = recap.headline
    self.photo    = recap.photo
    self.url      = recap.url
  end

  def content
    @content.to_s.gsub('\n', '').gsub(/\n/, '')
  end
end
