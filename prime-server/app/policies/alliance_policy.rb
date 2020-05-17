class AlliancePolicy < ApplicationPolicy
  def all_cars?
    manage?
  end

  def cars?
    user.can?("联盟车辆查询")
  end

  def car?
    user.can?("联盟车辆查询")
  end

  def all_companies?
    true
  end

  def companies?
    manage?
  end

  def companies_except_me?
    true
  end

  def company?
    manage?
  end

  def show?
    manage?
  end

  def update?
    manage? && owner?(record, user)
  end

  def destroy?
    manage? && owner?(record, user)
  end

  def manage?
    user.can?("联盟管理")
  end

  def master?
    user.in?(record.owner.enabled_users) && user.can?("联盟管理")
  end

  private

  def owner?(alliance, user)
    alliance.owner_id == user.company_id ||
      alliance.alliance_company_id == user.company_id
  end
end
