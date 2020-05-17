class Finance::ShopFeePolicy < ApplicationPolicy
  def index?
    finance_admin?
  end

  def export?
    finance_admin?
  end

  def update?
    finance_admin?
  end

  def finance_admin?
    user.can?("财务管理")
  end
end
