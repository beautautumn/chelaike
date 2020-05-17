class IntentionPolicy < ApplicationPolicy
  def update?
    return true if user.can?("全部客户管理")
    return true if manager?
    return true if after_sale_manager?
    record.assignee_id == user.id || record.assignee.try(:manager_id) == user.id
  end

  def show?
    update? ||
      record.intention_shared_users.exists?(user_id: user.id) ||
      record.to_be_recycled?
  end

  def destroy?
    user.can?("全部客户管理") || (seek_manager? && sale_manager?)
  end

  def create_push_history?
    show?
  end

  def customer_service_batch_assign?
    user.can?("坐席录入")
  end

  def manager?
    if record.intention_type.sale?
      sale_manager?
    else
      seek_manager?
    end
  end

  def seek_manager?
    user.can?("全部求购客户管理")
  end

  def sale_manager?
    user.can?("全部出售客户管理")
  end

  def after_sale_manager?
    return unless record.state == "completed"
    user.can?("售后管理")
  end

  def share?
    record.assignee_id == user.id
  end
end
