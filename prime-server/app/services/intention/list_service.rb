class Intention < ActiveRecord::Base
  class ListService
    def initialize(user, params)
      @user = user
      @params = params

      @order_field = parse_order_field(params[:order_field])
      @order_by = params[:order_by] == "asc" ? "ASC NULLS LAST" : "DESC NULLS FIRST"
    end

    def execute
      filter_expired(intentions_scope)
        .ransack(@params[:query]).result
        .order(Intention.order_by_state)
        .order(Intention.order_sql(@order_field, @order_by))
        .order("intentions.id desc")
    end

    def filter_expired(scope)
      return scope unless @params.key?(:expired)

      @params[:expired] ? scope.expired : scope.unexpired
    end

    def intentions_scope
      user_ids = find_users.map(&:id)

      case
      when @params[:task_type].present?
        intention_overstep_scope(user_ids).public_send(@params[:task_type])
      when @params[:task_statistic_type].present?
        TaskStatistic::Service.detail(
          intention_scope, User::IntentionService.related_users(@user).map(&:id), @params
        )
      when @params[:daily_management_user].present?
        DailyManagement::BaseService.detail(
          @user, @params[:daily_management_user], @params[:daily_management_type]
        )
      else
        scope = manager_intention_scope
        return scope if scope
        if @user.subordinate_users.present?
          intention_overstep_scope(user_ids)
        else
          @user.all_intentions
        end
      end
    end

    def intention_scope
      Intention.intention_scope(@user.company_id)
    end

    def manager_intention_scope
      if super_manager?
        intention_scope
      elsif @user.can?("全部求购客户管理")
        intention_scope.where(intention_type: :seek)
      elsif @user.can?("全部出售客户管理")
        intention_scope.where(intention_type: :sale)
      end
    end

    def intention_overstep_scope(user_ids)
      intention_scope.overstep(user_ids)
    end

    def find_users
      if @params[:user_ids].present?
        User.where(id: @params[:user_ids].split(",").map(&:squish!))
      else
        [@user]
      end
    end

    def parse_order_field(order_field)
      if order_field.blank? || order_field == "id"
        "intentions.id"
      else
        order_field
      end
    end

    private

    def super_manager?
      @user.can?("全部客户管理") || (@user.can?("全部求购客户管理") && @user.can?("全部出售客户管理"))
    end
  end
end
