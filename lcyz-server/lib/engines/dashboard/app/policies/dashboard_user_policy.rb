DashboardUserPolicy = Struct.new(:current_user, :user) do
  def index?
    manage?
  end

  def destroy?
    manage?
  end

  def token?
    current_user.admin?
  end

  private

  def manage?
    current_user.admin? || current_user.customer_service? || current_user.consultant?
  end
end
