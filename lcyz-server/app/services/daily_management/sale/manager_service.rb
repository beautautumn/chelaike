module DailyManagement
  module Sale
    class ManagerService < DailyManagement::Manager
      include DailyManagement::Sale::Base

      def initialize(user)
        @user = user
        @is_admin = user.can?("全部客户管理") || user.can?("全部求购客户管理")
      end

      private

      def authority
        ["求购客户管理"]
      end
    end
  end
end
