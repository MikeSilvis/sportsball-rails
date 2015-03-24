module Realtime
  Pusher.url = ENV['JUMBOTRON_PUSHER_URL']

  def self.client
    @client ||= Pusher
  end
end
