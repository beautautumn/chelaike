class Car < ActiveRecord::Base
  class ViewedCountService
    class << self
      def add(car_id)
        RedisClient.current.incr(
          cache_key(car_id)
        )
      end

      def show(car_id)
        RedisClient.current.get(
          cache_key(car_id)
        ).to_i
      end

      def cache_key(car_id)
        "#{name}:#{car_id}"
      end
    end
  end
end
