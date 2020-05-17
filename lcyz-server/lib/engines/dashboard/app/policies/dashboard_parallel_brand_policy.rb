DashboardParallelBrandPolicy = Struct.new(:user, :dashboard_parallel_brand) do
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

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
