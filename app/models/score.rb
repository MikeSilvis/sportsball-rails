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
        name: game[:away_team_name],
        logo: team.logo(game[:away_team]),
        wins: game[:away_team_record].split("-")[0],
        loses: game[:home_team_record].split("-")[1],
        record: game[:away_team_record],
        data_name: game[:away_team]
      }
      game[:home_team] = {
        name: game[:home_team_name],
        logo: team.logo(game[:home_team]),
        wins: game[:home_team_record].split("-")[0],
        loses: game[:home_team_record].split("-")[1],
        record: game[:home_team_record],
        data_name: game[:home_team]
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
