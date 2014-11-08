require 'open-uri'

class Team
  include SportsBall
  attr_accessor :data_name

  def all
    @all ||= ESPN.get_teams_in(league) if allowed_sport?
  end

  def find(team)
    all.values.flatten.detect { |h| h[:data_name] == team }
  end

  def logo(data_name)
    ActionController::Base.helpers.image_url("#{league}-teams/#{data_name}.png")
  end

  #concerning :DownloadingLogo do
    #class_methods do
      def self.score_data(array)
        array.each do |a|
          away_team = Team.new
          away_team.data_name = a[:away_team]
          away_team.download_logo(a[:away_team_logo])

          home_team = Team.new
          home_team.data_name = a[:home_team]
          home_team.download_logo(a[:home_team_logo])
        end
      end
    #end
    def download_logo(url)
      open("app/assets/images/#{league}-teams/#{data_name}.png", 'wb') do |file|
        file << open(url).read
      end
    end
  #end
end
