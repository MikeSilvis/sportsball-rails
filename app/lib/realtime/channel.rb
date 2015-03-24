class Realtime::Channel
  def self.increment
    client.incr channel_key
  end

  def self.decrement
    client.decr channel_key
  end

  def self.any?
    client.get(channel_key).to_i > 0
  end

  private

  def self.channel_key
    "channel_count"
  end

  def self.client
    @client ||= Redis.new(url: ENV['REDISTOGO_URL'])
  end
end
