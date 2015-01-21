require 'open-uri'

class PhotoFinder::Team
  attr_accessor :league, :team

  def initialize(team, league)
    self.league = league
    self.team   = team
  end

  def photos
    @photos ||= begin
                  markup.css('.result img').map do |photo|
                    photo_url     = Addressable::URI::parse(photo.attributes['src'].value)
                    query_params  = CGI.parse(photo_url.query)

                    next nil unless query_params['w'].first.to_i > query_params['h'].first.to_i

                    photo_url.to_s.gsub(/w=100&h=\d*/, 'w=1000')
                  end.compact
                end
  end

  def save(index)
    open("app/assets/images/#{league}-teams/headers/#{team[:data_name]}.png", 'wb') do |file|
      byebug
      file << open(photos[index.to_i]).read
    end
  end

  private

  def markup
    @markup ||= ESPN.get("#{league}/team/photos/_/name/#{team[:data_name]}")
  end
end
