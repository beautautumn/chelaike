module DailyManagement
  module Appraisement
    class ManagerService < DailyManagement::Manager
      include DailyManagement::Appraisement::Base

      def initialize(user)
        @user = user
        @is_admin = user.can?("全部客户管理") || user.can?("全部出售客户管理")
      end

      private

      def authority
        ["出售客户管理"]
      end
    end
  end
end
