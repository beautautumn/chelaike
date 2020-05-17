if Rails.env.docker?
  redis_url = "redis://#{ENV.fetch("REDIS_1_PORT_6379_TCP_ADDR")}:6379"
else
  redis_url = ENV.fetch("REDIS_URL")
end

Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 2
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
