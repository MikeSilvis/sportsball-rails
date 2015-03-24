class Realtime::Checker
  attr_accessor :channels

  def self.push_updates
    channels.each do |channel, _|
      params = channel.split('_')
      if params[0] == 'scores'
        Realtime::Publisher.send_scores(params[1])
      elsif params[0] == 'boxscore'
        Realtime::Publisher.send_boxscore(params[1], params[2])
      end
    end
  end

  private

  def self.channels
    @channels ||= Realtime.client.channels[:channels]
  end
end