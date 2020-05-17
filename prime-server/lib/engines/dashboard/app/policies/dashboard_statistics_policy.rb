DashboardStatisticsPolicy = Struct.new(:user, :dashboard_statistics) do
  def index?
    manage?
  end

  def show?
    manage?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        Company.all
      else
        user.companies
      end
    end
  end

  private

  def manage?
    user.admin? || user.consultant?
  end
end
