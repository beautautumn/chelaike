DashboardOrderPolicy = Struct.new(:user, :dashboard_order) do
  def index?
    manage?
  end

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
