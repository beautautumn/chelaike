class AllianceStockOutInventoryPolicy < ApplicationPolicy
  def show?
    user.can?("收购价格查看") || owner?
  end

  def create?
    user.can?("在库车辆出库")
  end

  def update?
    user.can?("在库车辆出库")
  end

  private

  def owner?
    record.seller_id == user.id
  end
end
