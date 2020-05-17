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
  end
end
