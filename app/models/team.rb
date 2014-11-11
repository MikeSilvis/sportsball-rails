require 'open-uri'

class Team
  include SportsBall
  attr_accessor :data_name, :name, :logo, :wins, :loses, :record
  POSSIBLE_TEAMS = %w[away home]

  def initialize(attrs, team)
    return nil unless POSSIBLE_TEAMS.include?(team)

    self.name      = attrs["#{team}_team_name".to_sym]
    self.record    = attrs["#{team}_team_record".to_sym]
    self.data_name = attrs["#{team}_team".to_sym]
    self.league    = attrs[:league]
  end

  def as_json
    {
      name: self.name,
      logo: self.logo,
      record: self.record,
      data_name: self.data_name
    }
  end
  add_method_tracer :as_json, 'Team/as_json'

  def all
    @all ||= ESPN.get_teams_in(league) if allowed_sport?
  end

  def find(team)
    all.values.flatten.detect { |h| h[:data_name] == team }
  end

  def logo(rabble_name = nil)
    ActionController::Base.helpers.image_url("#{league}-teams/#{self.data_name}.png")
  end

  module DownloadingLogo
    def self.score_data(array)
      array.each do |a|
        away_team = Team.new(a, 'away')
        away_team.download_logo(a[:away_team_logo])

        home_team = Team.new(a, 'home')
        home_team.download_logo(a[:home_team_logo])
      end
    end

    def download_logo(url)
      open("app/assets/images/#{league}-teams/#{data_name}.png", 'wb') do |file|
        file << open(url).read
      end
    end
  end
  include DownloadingLogo
end
