module Util
  class Jpush
    attr_reader :client

    def initialize
      ActiveRecord::Base.clear_active_connections!

      @client = ::JPush::JPushClient.new(
        ENV.fetch("JPUSH_APP_KEY"), ENV.fetch("JPUSH_MASTER_SECRET")
      )
    end

    def send(payload)
      return if RedisClient.current.get("system_jpush").present?

      begin
        @client.sendPush(payload)
      rescue JPush::ApiConnectionException => e
        Rails.logger.info e.message
      end
    end

    def self.users_tag(user_ids)
      user_ids.map { |id| "user_#{id}" }
    end
  end
end
