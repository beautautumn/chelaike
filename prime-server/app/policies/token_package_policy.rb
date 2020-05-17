class TokenPackagePolicy < ApplicationPolicy
  def index?
    true
  end

  def buy?
    user.can?("车币充值")
  end

  def free_buy?
    user.can?("车币充值")
  end
end
