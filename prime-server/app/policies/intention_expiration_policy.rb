class IntentionExpirationPolicy < SystemSettingPolicy
  def update?
    user.can?("业务设置")
  end

  def show?
    true
  end
end
