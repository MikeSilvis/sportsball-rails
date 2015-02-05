class Nhl::Recap < Nhl::Info
  def url
    @url ||= "http://www.nhl.com/gamecenter/en/recap?id=#{game_id}"
  end

  def cache_key
    @cache_key ||= "nhl_recap_cache_#{game_id}"
  end
end
