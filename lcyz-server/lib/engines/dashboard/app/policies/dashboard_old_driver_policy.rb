DashboardOldDriverPolicy = Struct.new(:user, :dashboard_old_driver) do
  def index?
    manage?
  end

  def show?
    true
  end

  def create?
    index?
  end

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
