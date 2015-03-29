class RealtimeWebhookController < ApplicationController
  skip_before_filter :ensure_valid_league

  def create
    if webhook.valid?
      #Realtime::Channel.verify

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
