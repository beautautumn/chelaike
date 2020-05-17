module DailyManagement
  class BaseService
    GROUPS = {
      acquisition_infos: "DailyManagement::AcquisitionCarInfo::AllService", # 收车评估
      sale_manager: "DailyManagement::Sale::ManagerService",
      sale_user: "DailyManagement::Sale::UserService"
    }.freeze

    REMINDER_FIELDS = {
      acquisition_infos: "",
      sale_manager: %i(untreated_intentions_count),
      sale_user: %i(
        pending_intentions_count
        pending_dealing_intentions_count_today
        expired_dealing_intentions_count_today
      )
    }.freeze

    def initialize(user)
      @user = user
      @is_admin = user.can?("全部客户管理")
    end

    def execute
      {}.tap do |hash|
        GROUPS.each do |key, klass|
          instance = klass.constantize.new(@user)

          next unless instance.can?
          hash[key] = instance.execute
        end
      end
    end

    def intention_type
      raise "You have to rewrite this method"
    end

    def seek_intention?
      intention_type == "seek".freeze
    end

    def unfinished_intentions
      scope.where(state: Intention.state_unfinished)
    end

    def finished_intentions
      scope.where(state: Intention.state_finished)
    end

    def admin_scope
      Intention.intention_scope(@user.company_id)
               .where(intention_type: intention_type)
               .with_customer
    end

    def intentions
      scope.where(intention_type: intention_type)
    end

    def can?
      @user.can?(*authority)
    end

    def admin?
      @is_admin || @user.can?(*admin_authority)
    end

    def self.detail(user, group, type)
      module_name, class_name = group.split("_").map(&:classify)

      DailyManagement.const_get(module_name.classify)
                     .const_get("#{class_name}_service".classify)
                     .new(user)
                     .public_send(type)
    end

    def unread?
      GROUPS.each do |key, klass|
        instance = klass.constantize.new(@user)

        next unless instance.can?
        instance.execute.dup.extract!(*REMINDER_FIELDS.fetch(key)).each do |_, value|
          return true unless value == 0
        end
      end

      false
    end
  end
end
