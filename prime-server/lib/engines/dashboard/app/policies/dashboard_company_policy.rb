DashboardCompanyPolicy = Struct.new(:user, :dashboard_company) do
  def index?
    user.present?
  end

  def show?
    manage?
  end

  def destroy?
    manage?
  end

  def edit_token?
    user.financial? || user.admin?
  end

  def update_token?
    user.financial? || user.admin?
  end

  def edit_advisor?
    manage?
  end

  def update_advisor?
    manage?
  end

  def reset_boss?
    manage?
  end

  def honesty_tag?
    manage?
  end

  def active_tag?
    manage?
  end

  def own_brand_tag?
    manage?
  end

  def clear_tag?
    user.admin?
  end

  def manage_active_tag?
    manage?
  end

  def clear_manage_tag?
    user.admin?
  end

  def add_label?
    manage?
  end

  def update_label?
    manage?
  end


 private

  def manage?
    user.admin? || user.customer_service?
  end
end
