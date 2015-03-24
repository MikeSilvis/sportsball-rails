class RealtimeWebhookController < ApplicationController
  def create
    if webhook.valid?
      webhook.events.each do |event|
        if event['name'] == 'channel_occupied'
          Realtime::Channel.increment
        elsif event['name'] == 'channel_vacated'
          Realtime::Channel.decrement
        end
      end

      render text: 'ok'
    else
      render text: 'invalid', status: 401
    end
  end

  private

  def webhook
    @webhook ||= Pusher::WebHook.new(request)
  end
end
