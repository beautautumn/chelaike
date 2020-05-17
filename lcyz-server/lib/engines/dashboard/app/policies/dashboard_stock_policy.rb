DashboardStockPolicy = Struct.new(:user, :dashboard_stock) do
  def index?
    manage?
  end

  private

    def manage?
      user.admin? || user.customer_service?
    end
end
