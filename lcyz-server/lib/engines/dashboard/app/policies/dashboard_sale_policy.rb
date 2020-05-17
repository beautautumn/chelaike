DashboardSalePolicy = Struct.new(:user, :dashboard_sale) do
  def index?
    manage?
  end

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
