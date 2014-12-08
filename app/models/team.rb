require 'open-uri'

class Team
  include SportsBall
  attr_accessor :data_name, :name, :logo, :wins, :loses, :record, :rank

  def initialize(attrs, team = nil)
    prefix = team ? "#{team}_" : nil

    self.name      = attrs["#{prefix}team_name".to_sym]
    self.record    = attrs["#{prefix}team_record".to_sym]
    self.data_name = attrs["#{prefix}team".to_sym]
    self.rank      = attrs["#{prefix}team_rank".to_sym]
    self.league    = attrs[:league]
  end

  def as_json(*)
    {
      name: name,
      logo: logo,
      record: record,
      data_name: data_name,
      rank: rank
    }.compact
  end
  add_method_tracer :as_json, 'Team/as_json'

  def logo
    ActionController::Base.helpers.image_url("#{league}-teams/#{data_name}.png")
  end

  module DownloadingLogo
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def score_data(array)
        array.each do |a|
          away_team = Team.new(a, 'away')
          away_team.download_logo(a[:away_team_logo])

          home_team = Team.new(a, 'home')
          home_team.download_logo(a[:home_team_logo])
        end
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
