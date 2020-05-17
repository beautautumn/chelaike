module DailyManagement
  module Sale
    module Base
      def intention_type
        "seek".freeze
      end

      def admin_authority
        %w(求购客户管理)
      end
    end
  end
end
