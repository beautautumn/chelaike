class Finance::CarIncomePolicy < ApplicationPolicy
  def index?
    finance_admin?
  end

  def show?
    finance_admin?
  end

  def create?
    finance_admin?
  end

  def export?
    finance_admin?
  end

  def update?
    finance_admin?
  end

  # 可能还需要增加车辆信息编辑权限的限制
  def update_price?
    finance_admin?
  end

  def update_fund_rate?
    finance_admin?
  end

  def batch_update?
    finance_admin?
  end

  def payment?
    finance_admin?
  end

  def receipt?
    finance_admin?
  end

  def finance_admin?
    user.can?("财务管理")
  end
end
