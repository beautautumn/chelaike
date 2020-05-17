module DailyManagement
  class Manager < DailyManagement::BaseService
    def execute
      {
        untreated_intentions_count: untreated_intentions.size,
        pending_intentions_count: pending_intentions.size
      }.tap do |hash|
        if seek_intention?
          hash[:finished_intentions_count] = finished_intentions.size
          hash[:unfinished_intentions_count] = unfinished_intentions.size
        else
          hash[:intentions_count] = intentions.size
        end
      end
    end

    # 新客户待分配
    def untreated_intentions
      admin? ? admin_scope.where(state: "untreated") : Intention.none
    end

    # 员工未处理
    def pending_intentions
      scope.pending_dealing
    end

    def scope
      @is_admin ? admin_scope : admin_scope.overstep([@user.id])
    end
  end
end
