class WechatAppPolicy < ApplicationPolicy
  def show?
    manage?
  end

  def update?
    manage?
  end

  def publish?
    manage?
  end

  def manage?
    user.can?("微店管理权限")
  end
end
