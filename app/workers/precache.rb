class Precache
  include Sidekiq::Worker

  def perform
    Rails.cache.clear
    ESPN::Cache.precache
  end
end
