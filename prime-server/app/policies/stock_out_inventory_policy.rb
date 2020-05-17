class StockOutInventoryPolicy < ApplicationPolicy
  def manage?
    user.can?("在库车辆出库")
  end

  def show?
    true
  end
end
