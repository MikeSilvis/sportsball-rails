require 'pusher'

class Realtime::Publisher
  Pusher.url = ENV['JUMBOTRON_PUSHER_URL']

  def self.send(league, game_id)
    game_id = game_id.to_s

    Pusher["boxscore_#{league}_#{game_id}"].trigger('event', {
      boxscore: Boxscore.find(league, game_id),
      game: League.new(league).scores(ActiveSupport::TimeZone['America/New_York'].today).detect { |s| s.boxscore == game_id }
    })
  end

  def today
    ActiveSupport::TimeZone['America/New_York'].today
  end
end
