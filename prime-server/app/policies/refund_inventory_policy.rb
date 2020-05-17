class RefundInventoryPolicy < ApplicationPolicy
  def manage?
    user.can?("出库车辆回库")
  end
end
