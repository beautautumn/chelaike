DashboardXiaoCheChePolicy = Struct.new(:user, :dashboard_xiao_che_che) do
  def index?
    manage?
  end

  def new?
    manage?
  end

  def publish?
    manage?
  end

  private

  def manage?
    user.developer? || user.admin?
  end
end
