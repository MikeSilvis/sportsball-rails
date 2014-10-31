class Score
  include SportsBall

  def all(date = Date.today)
    date = Date.today unless date

    if league == 'nfl'
      ESPN.get_nfl_scores(date.year, 3)
    else
      ESPN.public_send("get_#{league}_scores", date) if allowed_sport?
    end
  end
end
