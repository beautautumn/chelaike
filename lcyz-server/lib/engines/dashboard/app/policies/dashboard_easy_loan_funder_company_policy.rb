DashboardEasyLoanFunderCompanyPolicy = Struct.new(:user, :dashboard_easy_loan_setting) do
  def index?
    manage?
  end

  def show?
    manage?
  end

  def new?
    manage?
  end

  def update?
    manage?
  end

  def create?
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
