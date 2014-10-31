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
        logo: "http://upload.wikimedia.org/wikipedia/ang/c/cd/Panthers_tacn.png",
        wins: "5",
        loses: "3"
      }
      game[:home_team] = {
        name: team.find(game[:home_team]).try(:fetch, :name),
        logo: "http://img4.wikia.nocookie.net/__cb20100914172946/logopedia/images/0/00/200px-Pittsburgh_Penguins_logo_1972-1992_svg.png",
        wins: "20",
        loses: "1"
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
