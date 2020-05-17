module DailyManagement
  module Appraisement
    class UserService < DailyManagement::User
      include DailyManagement::Appraisement::Base

      private

      def authority
        ["出售客户跟进"]
      end
    end
  end
end
