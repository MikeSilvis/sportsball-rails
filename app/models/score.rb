class Score
  include SportsBall

  def team
    @team||= Team.new.tap do |t|
              t.league = self.league
            end
  end

  def all(date = Date.today)
    find(date).map do |game|
      game[:away_team] = {
        name: team.find(game[:away_team]).try(:fetch, :name),
        logo: "",
        wins: "",
        loses: ""
      }
      game[:home_team] = {
        name: team.find(game[:home_team]).try(:fetch, :name),
        logo: "",
        wins: "",
        loses: ""
      }
      game
    end
  end

  def find(date = Date.today)
    date = Date.today unless date

    if league == 'nfl'
      ESPN.get_nfl_scores(date.year, 3)
    else
      ESPN.public_send("get_#{league}_scores", date) if allowed_sport?
    end
  end
end
