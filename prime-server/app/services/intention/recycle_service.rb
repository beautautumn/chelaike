class Intention < ActiveRecord::Base
  class RecycleService
    include ErrorCollector

    class NoExpirationSetError < StandardError; end

    def initialize(user, params)
      @user = user
      @params = params
      raise NoExpirationSetError, "该公司未设置意向过期时间, 此功能不可用" unless @user.company.intention_expiration
      @scope = Intention.intention_scope(@user.company_id)
                        .to_be_recycled(@user.company.intention_expiration.recovery_time)
    end

    def list
      @order_field = parse_order_field(@params[:order_field])
      @order_by = @params[:order_by] == "asc" ? "ASC NULLS LAST" : "DESC NULLS FIRST"
      manager_recycle_scope.ransack(@params[:query]).result
                           .order(Intention.order_by_state)
                           .order(Intention.order_sql(@order_field, @order_by))
                           .order("intentions.id desc")
    end

    def recycle
      intentions = manager_recycle_scope
      return [] if intentions.blank?
      intention_params = { assignee: @user,
                           state: "processing",
                           processing_time: Time.zone.now.beginning_of_day
                         }
      processed = []
      intentions.each do |intention|
        # 修改归属人为自己, 状态为 "待跟进", 跟进时间为今天
        intention.update!(intention_params)
        # 删除之前的共享关系
        intention.intention_shared_users.destroy_all
        processed << intention.id
      end
      processed
    end

    def manager_recycle_scope
      if super_manager?
        recycle_scope
        # 普通销售/销售主管
      elsif @user.can?("求购客户跟进") || @user.can?("求购客户管理")
        recycle_scope.where(intention_type: :seek)
        # 普通收购/收购主管
      elsif @user.can?("出售客户跟进") || @user.can?("出售客户管理")
        recycle_scope.where(intention_type: :sale)
      else
        Intention.none
      end
    end

    def recycle_scope
      if @params[:intention_ids].present?
        @scope.where(id: @params[:intention_ids])
      else
        @scope
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
