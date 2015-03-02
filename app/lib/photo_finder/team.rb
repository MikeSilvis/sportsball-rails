require 'open-uri'
require 'league'

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

  def save_by_url(url)
    open(file_location, 'wb') do |file|
      file << open(URI.parse(URI.encode(url.strip))).read
    end
  end

  def has_photo?
    File.exists?(file_location) || s3_photos.include?(team[:data_name])
  end

  def s3_photos
    @s3_photos ||= League.new(league).header_images.keys.to_set
  end

  private

  def file_location
    "app/assets/images/#{league}-teams/headers/#{team[:data_name]}.jpg"
  end

  def markup
    @markup ||= ESPN.get("#{league}/team/photos/_/#{by}/#{team[:data_name]}")
  end

  def by
    league == 'ncb' ? 'id' : 'name'
  end
end
