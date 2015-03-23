require 'pusher'

class Realtime::Publisher
  Pusher.url = ENV['JUMBOTRON_PUSHER_URL']

  def self.send_boxscore(league, game_id)
    game_id = game_id.to_s
    boxscore = Boxscore.find(league, game_id)

    push_event("boxscore_#{league}_#{game_id}", {
      boxscore: boxscore,
      game: League.new(league).scores(boxscore.game_date.to_date).detect { |s| s.boxscore == game_id }
    })
  end

  def self.send_scores(league, date)
    push_event("scores_#{league}_#{date.strftime('%Y-%m-%d')}", {
      scores: League.new(league).scores(date)
    })
  end

  def self.push_event(channel, data)
    client.trigger(channel, 'event', data)
  end

  def today
    ActiveSupport::TimeZone['America/New_York'].today
  end

  def self.client
    Pusher
  end
end
