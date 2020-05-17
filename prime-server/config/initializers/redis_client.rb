module RedisClient
  module_function

  def current
    @_redis ||= Redis.new(url: ENV["REDIS_URL"])
  end
end
