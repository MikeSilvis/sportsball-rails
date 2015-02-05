class Nhl::Preview < Nhl::Info
  def url
    @url ||= "http://www.nhl.com/gamecenter/en/preview?id=#{game_id}"
  end

  def cache_key
    @cache_key ||= "nhl_preview_cache_#{game_id}"
  end
end
