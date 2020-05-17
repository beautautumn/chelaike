class CarStateHistoryPolicy < ApplicationPolicy
  def manage?
    user.can?("车辆状态修改")
  end
end
