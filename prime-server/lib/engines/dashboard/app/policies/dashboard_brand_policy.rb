DashboardBrandPolicy = Struct.new(:user, :dashboard_brand) do
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

  def show?
    manage?
  end

  private

  def manage?
    user.present?
  end
end
