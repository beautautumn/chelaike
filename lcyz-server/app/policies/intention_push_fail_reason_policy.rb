class IntentionPushFailReasonPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    manage?
  end

  def create?
    manage?
  end

  def manage?
    authority = "业务设置"

    user.can?(authority)
  end

  def app_index?
    true
  end
end
