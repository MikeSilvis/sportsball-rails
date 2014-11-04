class Team
  include SportsBall

  def all
    @all ||= ESPN.get_teams_in(league) if allowed_sport?
  end

  def find(team)
    all.values.flatten.detect { |h| h[:data_name] == team }
  end

  def logo(data_name)
    ActionController::Base.helpers.image_url("#{league}-teams/#{data_name}.png")
  end
end
