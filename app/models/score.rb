class Score
  include SportsBall

  def scores(date = Date.today)
    ESPN.public_send("get_#{league}_scores", date) if allowed_sport?
  end
end
