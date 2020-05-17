class SystemSettingPolicy < ApplicationPolicy
  def manage?
    user.can?("业务设置")
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.where(company_id: user.company_id) if user.can?("业务设置")

      raise Pundit::NotAuthorizedError
    end
  end
end
