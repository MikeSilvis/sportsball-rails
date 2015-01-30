require 'open-uri'

class Team < QueryBase
  include SportsBall
  attr_accessor :data_name,
                :name,
                :logo,
                :wins,
                :loses,
                :record,
                :rank,
                :logo

  def initialize(attrs, team = nil)
    prefix = team ? "#{team}_" : nil

    self.name      = attrs["#{prefix}team_name".to_sym].to_s.strip
    self.record    = attrs["#{prefix}team_record".to_sym]
    self.data_name = attrs["#{prefix}team".to_sym]
    self.rank      = attrs["#{prefix}team_rank".to_sym]
    self.league    = attrs[:league]
  end

  def logo
    self.class.logo(league, data_name)
  end

  def self.logo(league, data_name)
    api_image_url("#{league}-teams/logos/#{data_name}")
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
      open("app/assets/images/#{league}-teams/logos/#{data_name}.png", 'wb') do |file|
        file << open(url).read
      end
    end
  end
  include DownloadingLogo
end
