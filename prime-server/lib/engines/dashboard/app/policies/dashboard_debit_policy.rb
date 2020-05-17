DashboardDebitPolicy = Struct.new(:user, :dashboard_debit) do
  def publish_page?
    true
  end

  def publish?
    true
  end
end
