module DailyManagement
  module Appraisement
    module Base
      def intention_type
        "sale".freeze
      end

      def admin_authority
        %w(出售客户管理)
      end
    end
  end
end
