class ShopPolicy < ApplicationPolicy
  def index?
    true
  end

  def manage?
    authority = "业务设置"

    return user.can?(authority) if record.id == user.shop_id
    user.cross_shop_can?(authority)
  end

  def update?
    manage?
  end

  def create?
    manage?
  end

  def destroy?
    manage?
  end

  def query_city?
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
        @scope = scope.where(id: user.shop_id)
      end
    end
  end
end
