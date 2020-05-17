class AuthorityRolePolicy < ApplicationPolicy
  def manage?
    user.can?("角色管理")
  end

  def show?
    true
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(company_id: user.company_id) if user.can?("角色管理")

      raise Pundit::NotAuthorizedError
    end
  end
end
