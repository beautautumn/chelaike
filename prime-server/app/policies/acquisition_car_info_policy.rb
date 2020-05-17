class AcquisitionCarInfoPolicy < ApplicationPolicy
  def create?
    user.can?("车辆新增入库")
  end

  def assign?
    sale_manager?
  end

  def update?
    if record.acquirer_id.nil?
      sale_manager?
    else
      record.acquirer_id == user.id
    end
  end

  def sale_manager?
    user.can?("全部出售客户管理") || user.can?("全部客户管理")
  end
end
