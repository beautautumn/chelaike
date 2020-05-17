DashboardAlliancePolicy = Struct.new(:user, :dashboard_alliance) do
  def index?
    manage?
  end

  def create?
    manage?
  end

  def edit?
    manage?
  end

  def update?
    manage?
  end

  def destroy?
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

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
