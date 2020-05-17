class Reporter::ReportTypes::CustomerServiceIntention
  attr_reader :user, :name
  def initialize(user, params)
    @user = user
    @name = "坐席录入导出#{Time.zone.now.strftime("%Y%m%d")}.xls"
    @params = params
  end

  def export
    HoneySheet::Excel.package(
      @name, Reporter::ReportTypes::Intention.title_bar, records
    )
  end

  def records
    Enumerator.new do |yielder|
      order_by = @params[:order_by] == "asc" ? "ASC NULLS LAST" : "DESC NULLS FIRST"
      order_field = @params[:order_field].blank? ? "intentions.id" : params[:order_field]
      scope = Intention.where(creator_id: @user.id, creator_type: "User")
                       .with_customer
                       .ransack(@params[:query]).result
                       .order("#{order_field} #{order_by}")
                       .order("intentions.id")

      scope.find_each do |intention|
        yielder << Reporter::ReportTypes::Intention.row_format(intention)
      end
    end
  end
end
