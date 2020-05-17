class AllianceCompanyRelationshipPolicy < ApplicationPolicy
  def manage?
    user.can?("联盟管理")
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end
end
