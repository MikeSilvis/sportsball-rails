class Nhl::Preview < Nhl::Info
  def url
    @url ||= "http://www.nhl.com/gamecenter/en/preview?id=#{game_id}"
  end
end
