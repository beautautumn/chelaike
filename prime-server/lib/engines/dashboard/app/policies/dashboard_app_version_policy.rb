DashboardAppVersionPolicy = Struct.new(:user, :dashboard_app_version) do
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
    user.developer? || user.admin?
  end
end
