module V1
  class ReportsController < ApplicationController
    before_action :skip_authorization

    def new
      param! :report_type, String, required: true

      report = Reporter.new(current_user, params[:report_type], params)

      headers["Cache-Control"] = "no-cache"
      headers["Content-Type"] = "text/event-stream; charset=utf-8"
      headers["Content-disposition"] = "attachment; filename=\"#{report.report_name}\""
      headers["X-Accel-Buffering"] = "no"
      headers.delete("Content-Length")

      self.response_body = report.export
    end

    # 数据导出的查询内容
    def index
      param! :report_type, String, required: true

      authorized = case params[:report_type]
                   when "bm_cars"
                     current_user.can?("库存明细导出")
                   when "bm_intention"
                     current_user.can?("客户明细导出")
                   when "bm_sold_out"
                     current_user.can?("销售明细导出")
                   end

      raise Pundit::NotAuthorizedError unless authorized

      report = Reporter.new(current_user, params[:report_type], params)
      records = report.query_result

      send("render_#{params[:report_type]}", records)
    end

    private

    def render_bm_cars(records)
      records = paginate records
      render json: records,
             each_serializer: CarSerializer::BmReport,
             root: "data"
    end

    def render_bm_intention(records)
      records = paginate records
      render json: records,
             each_serializer: IntentionSerializer::BmReport,
             root: "data"
    end

    def render_bm_sold_out(records)
      records = paginate records
      render json: records,
             each_serializer: StockOutInventorySerializer::BmReport,
             root: "data"
    end
  end
end
