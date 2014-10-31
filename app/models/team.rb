class Team
  include SportsBall

  def all
    ESPN.get_teams_in(league) if allowed_sport?
  end
end
