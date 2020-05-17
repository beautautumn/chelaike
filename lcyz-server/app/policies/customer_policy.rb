class CustomerPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    true
  end

  def destroy?
    user.can?("删除客户")
  end

  def create?
    true
  end
end
