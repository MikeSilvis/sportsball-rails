require 'pusher'

class Realtime::Publisher
  Pusher.url = ENV['JUMBOTRON_PUSHER_URL']

  def self.send(league, game_id)
    game_id = game_id.to_s

    Pusher["boxscore_#{league}_#{game_id}"].trigger('event', {
      boxscore: Boxscore.find(league, game_id),
      game: League.new(league).scores.detect { |s| s.boxscore == game_id }
    })
  end
end
