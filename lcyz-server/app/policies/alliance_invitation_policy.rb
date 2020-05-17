class AllianceInvitationPolicy < ApplicationPolicy
  def agree?
    manage?
  end

  def disagree?
    agree?
  end

  def manage?
    user.can?("联盟管理")
  end
end
