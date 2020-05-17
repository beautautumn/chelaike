# 访问接口，得到报告详情
module ChaDoctorService
  class GetReport
    class InternalError < StandardError; end
    class ExternalError < StandardError; end

    attr_accessor :hub

    def initialize(hub)
      @hub = hub
    end

    def execute
      result = ChaDoctorService::API.get_report_json(hub.order_id)
      summany_status_data = ChaDoctorService::API.parse_summary_data(pc_url)

      case result.status
      when :success
        handle_success(result.data.merge(summany_status_data.data))
        self
      when :internal_error
        raise InternalError, result.message
      when :external_error
        raise ExternalError, result.message
      end
    end

    private

    def handle_success(result_data)
      hub.update!(
        fetch_info_at: Time.zone.now,
        brand_name: result_data.fetch("brand", ""),
        series_name: result_data.fetch("seriesname", ""),
        style_name: result_data.fetch("modelname", ""),
        engine_no: result_data.fetch("enginno", ""),
        report_details: result_data,
        report_no: result_data.fetch("reportNo", ""),
        make_report_at: result_data.fetch("makeReportDate", ""),
        pc_url: pc_url,
        mobile_url: mobile_url,
        summany_status_data: result_data.fetch(:summany_status_data)
      )
    end

    def pc_url
      "http://api.chaboshi.cn/new_report/show_report?#{report_url_query_string}"
    end

    def mobile_url
      "http://api.chaboshi.cn/new_report/show_reportMobile?#{report_url_query_string}"
    end

    def report_url_query_string
      attrs = { orderid: @hub.order_id }
      signed = ChaDoctorService::Util.signed_params(attrs)
      ChaDoctorService::Util.sort_params(signed)
    end
  end
end
