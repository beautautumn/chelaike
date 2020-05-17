module RedisClientHelper
  RedisClient.module_eval do
    def self.current
      @redis ||= Redis.new(url: ENV["REDIS_URL"])
      @redis.select 1

      @redis
    end
  end
end
