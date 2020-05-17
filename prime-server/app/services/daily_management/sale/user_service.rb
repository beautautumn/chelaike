module DailyManagement
  module Sale
    class UserService < DailyManagement::User
      include DailyManagement::Sale::Base

      private

      def authority
        ["求购客户跟进"]
      end
    end
  end
end
