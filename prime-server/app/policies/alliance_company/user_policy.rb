module AllianceCompany
  class UserPolicy < ApplicationPolicy
    def manage?
      # User::Pundit.can_can?(user, record, ["员工管理"])
      user.can?("员工管理")
    end

    def update?
      user.id == record.id || manage?
    end

    def state?
      manage?
    end

    def show?
      true
    end

    def custom?
      manage?
    end

    def authority_roles?
      true
    end

    def index?
      true
    end

    def selector?
      index?
    end

    def task_statistic?
      if user.can?("全部客户管理")
        true
      else
        user.id == record.id || record.manager_id == user.id
      end
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        @scope
      end
    end
  end
end
