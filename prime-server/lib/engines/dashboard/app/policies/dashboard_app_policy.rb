DashboardAppPolicy = Struct.new(:user, :dashboard_app) do
  def index?
    manage?
  end

  def new?
    create?
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
