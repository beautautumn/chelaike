DashboardIntentionPolicy = Struct.new(:user, :dashboard_intention) do
  def index?
    manage?
  end

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
