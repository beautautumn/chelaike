DashboardParallelStylePolicy = Struct.new(:user, :dashboard_parallel_style) do
  def index?
    manage?
  end

  def new?
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

  def delete_image?
    manage?
  end

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
