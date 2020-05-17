module DailyManagement
  module AcquisitionCarInfo
    class AllService < DailyManagement::BaseService
      def initialize(user)
        @user = user
        @current_company = @user.company
        @is_admin = user.can?("全部客户管理") || user.can?("全部出售客户管理")
      end

      def intention_type
        ""
      end

      def execute
        sql = <<-SQL.squish!
          COUNT(*) as total_count,
          COUNT(CASE WHEN
            acquisition_car_infos.state = 'init' THEN 1
          END) as init_count,
          COUNT(CASE WHEN
            acquisition_car_infos.state = 'finished' THEN 1
          END) as finished_count,
          COUNT(CASE WHEN
            acquisition_car_infos.state = 'unassigned' THEN 1
          END) as unassigned_count
        SQL

        result = infos_scope.select(sql).to_a

        base_hash = {
          infos_count: result.first.total_count,
          following_count: result.first.init_count,
          finished_count: result.first.finished_count
        }

        base_hash = base_hash.merge(
          unassigned_count: result.first.unassigned_count
        ) if @is_admin

        base_hash
      end

      def infos_scope
        if @is_admin
          @current_company.acquisition_car_infos
        elsif @user.can?("出售客户管理")
          ::AcquisitionCarInfo.where(acquirer_id: ::User.subordinate_users_with_self(@user.id))
        else
          @user.acquisition_car_infos
        end
      end

      private

      def authority
        if @is_admin
          %w(全部出售客户管理)
        elsif @user.can?("出售客户管理")
          %w(出售客户管理)
        else
          %w(出售客户跟进)
        end
      end
    end
  end
end
