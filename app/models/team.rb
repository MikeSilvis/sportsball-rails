class Team
  include SportsBall

  def all
    @all ||= ESPN.get_teams_in(league) if allowed_sport?
  end

  def find(team)
    all.values.flatten.detect { |h| h[:data_name] == team }
  end
end
