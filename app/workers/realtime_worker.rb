class RealtimeWorker
  include Sidekiq::Worker

  def perform
    Realtime::Checker.push_updates
  end
end
