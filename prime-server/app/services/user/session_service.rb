class User < ActiveRecord::Base
  class SessionService
    include ErrorCollector::Handler

    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def create(password, req_headers = {})
      return unless @user && @user.enabled? && @user.authenticate(password)

      unless @user.valid?
        message = full_errors(@user).values.map(&:values).join(";")
        raise User::Unauthorized, "验证失败: #{message}"
      end

      current_sign_in_at = Time.zone.now
      @user.update_columns(
        last_sign_in_at:    @user.current_sign_in_at || current_sign_in_at,
        current_sign_in_at: current_sign_in_at,
        current_device_number: device_number(req_headers)
      )
    end

    private

    def device_number(req_headers)
      return req_headers["AutobotsDeviceNumber"] if platform(req_headers).in?(%w(ios android))
      @user.current_device_number
    end

    def platform(req_headers)
      req_headers["AutobotsPlatform"].try(:downcase)
    end
  end
end
