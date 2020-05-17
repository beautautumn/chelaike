class Reporter
  attr_reader :report_name

  def initialize(user, report_name, params)
    @user = user

    @report = Reporter::ReportTypes
              .const_get(report_name.to_s.camelize)
              .new(@user, params)

    @report_name = @report.name
  end

  def export
    @report.export
  end

  # 查询结果
  def query_result
    @report.query_result
  end
end
