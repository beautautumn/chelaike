module AllianceCompanyService
  module User
    LoginError = Class.new(StandardError)

    class Login
      attr_accessor :login_id, :password
      attr_reader :current_user

      def initialize(login_id, password)
        @login_id = login_id
        @password = password
      end

      def login
        user = AllianceCompany::User.where(
          "lower(username) = lower(?) OR lower(phone) = lower(?)",
          @login_id, @login_id
        ).first

        raise LoginError, "用户不存在" unless user
        raise LoginError, "手机号码不存在或密码错误" unless user.authenticate(@password)
        raise LoginError, "该用户不能使用" unless user.enabled?
        user
      end
    end
  end
end
