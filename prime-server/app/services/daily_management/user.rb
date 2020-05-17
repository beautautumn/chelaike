module DailyManagement
  class User < DailyManagement::BaseService
    def initialize(user)
      super

      @beginning_of_day = Time.zone.now.beginning_of_day
      @end_of_day = Time.zone.now.end_of_day
    end

    def execute
      {
        pending_intentions_count: pending_intentions.size,
        pending_dealing_intentions_count_today: pending_dealing_intentions.size,
        expired_dealing_intentions_count_today: expired_dealing_intentions.size,
        waiting_recycle_intentions_count: waiting_recycle_intentions.size
      }.tap do |hash|
        if seek_intention?
          hash[:finished_intentions_count] = finished_intentions.size
          hash[:unfinished_intentions_count] = unfinished_intentions.size
        else
          hash[:intentions_count] = intentions.size
        end
      end
    end

    # 新分配待处理
    def pending_intentions
      @user.all_intentions.where(state: "pending", intention_type: intention_type).with_customer
    end

    # 今日待处理
    def pending_dealing_intentions
      scope.pending_dealing_today
    end

    # 过期未处理
    def expired_dealing_intentions
      scope.expired_dealing
    end

    # 过期待回收
    def waiting_recycle_intentions
      return Intention.none unless @user.company.intention_expiration
      Intention
        .where(company_id: @user.company_id)
        .where(intention_type: :seek)
        .to_be_recycled(@user.company.intention_expiration.recovery_time)
    end

    def scope
      # return admin_scope if @is_admin
      # return admin_scope.overstep([@user.id]) if @user.can?(*admin_authority)

      @user.all_intentions.where(intention_type: intention_type).with_customer
    end
  end
end
