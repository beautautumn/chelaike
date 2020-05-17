module Search
  class RecentKeywordsService
    attr_reader :limitation, :redis_key

    def initialize(type, user_id, options = {})
      @limitation = options.fetch(:limitation, 20).to_i

      @redis_key = "Search:RecentKeywordsService:#{type}:#{user_id}"
    end

    # 在 Sorted List 里面加入 keyword
    # 如果 List 的总数大于限制, 会将 list 前面的多余的 element 删除
    def append(keyword)
      return unless keyword.present?

      RedisClient.current.pipelined do
        zadd(keyword)

        @size = RedisClient.current.zcount(redis_key, "-inf", "+inf")
      end

      return unless @size.value > @limitation

      RedisClient.current.zremrangebyrank(redis_key, 0, @size.value - @limitation - 1)
    end

    def all
      RedisClient.current.zrevrangebyscore(redis_key, "+inf", "-inf")
    end

    def zadd(keyword)
      RedisClient.current.zadd(redis_key, Time.zone.now.to_f, keyword.to_s)
    end
  end
end
