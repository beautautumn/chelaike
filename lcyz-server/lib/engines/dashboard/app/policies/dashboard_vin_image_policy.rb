DashboardVinImagePolicy = Struct.new(:user, :dashboard_vin_image) do
  def index?
    manage?
  end

  def show?
    true
  end

  def start_query?
    true
  end

  def response_error?
    true
  end

  private

  def manage?
    user.admin? || user.customer_service?
  end
end
