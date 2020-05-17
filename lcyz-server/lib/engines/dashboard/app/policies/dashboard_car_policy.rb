DashboardCarPolicy = Struct.new(:user, :dashboard_car) do
  def show?
    !user.nil?
  end

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
