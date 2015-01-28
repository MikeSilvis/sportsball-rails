class Nhl::Recap < Nhl::Info
  def url
    @url ||= "http://www.nhl.com/gamecenter/en/recap?id=#{game_id}"
  end
end
