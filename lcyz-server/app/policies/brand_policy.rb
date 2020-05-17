class BrandPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # 不需要跨店权限
      @scope
    end
  end
end
