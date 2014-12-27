require 'timeout'
require 'byebug'

class League
  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def self.all
    [
      League.new('nfl'),
      League.new('ncf'),
      League.new('nhl')
    ]
  end

  def as_json(*)
    {
      name => {
        logo: Rails.application.routes.url_helpers.api_image_url("leagues/#{name}"),
        header_image: Rails.application.routes.url_helpers.api_image_url("leagues/#{name}-header"),
        header_blurred_image: Rails.application.routes.url_helpers.api_image_url("leagues/#{name}-header-blurred"),
        schedule: schedule
      }
    }.compact
  end

  def schedule
    Rails.cache.fetch("schedule_#{name}", expires_in: 1.year) do
      ESPN::Schedule.find(name)
    end
  end

  def scores(date = Date.today)
    Score.all(name, date)
  end
end
