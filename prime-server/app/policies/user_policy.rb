class UserPolicy < ApplicationPolicy
  def manage?
    User::Pundit.can_can?(user, record, ["员工管理"])
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
    return true if task_statistic_admin?

    user.id == record.id || record.manager_id == user.id
  end

  def mobile_app_car_detail_menu?
    true
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return @scope if user.company_unified_management

      if user.cross_shop_read || user.cross_shop_edit
        @scope
      else
        @scope = scope.where(shop_id: user.shop_id)
      end
    end
  end

  def task_statistic_admin?
    user.can?("全部客户管理") || user.can?("全部出售客户管理") || user.can?("全部求购客户管理")
  end
end
