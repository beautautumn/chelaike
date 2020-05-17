module Dashboard
  class MaintenancesController < ApplicationController

    helper_method :get_state_name, :get_origin_name

    before_action do
      authorize :dashboard_maintenance
    end

    def index
      @q = MaintenanceRecord.all
      staff_id = params[:staff_id]
      if staff_id && !staff_id.empty?
        company_ids = CompanyProperty.where(staff_id: staff_id).collect{|r| r.company_id}
        @q = @q.where("company_id IN (?)", company_ids)
      end
      @q = @q.ransack(params[:q])
      @maintenances = @q.result
                 .includes(:company, :car, :maintenance_record_hub)
                 .order("created_at desc")
                 .page(params[:page])
                 .per(20)
      @counter = @q.result.count
    end

    private
      def get_state_name (status)
        status_list = {
          "generating" => "生成中",
          "unchecked" => "已生成",
          "checked" => "已查看",
          "updating" => "更新中",
          "generating_fail" => "生成失败",
          "updating_fail" => "更新失败"
        }
        status_list.fetch(status, "未知")
      end

      def get_origin_name (origin)
        origin_list = {
          "ant_queen" => "蚂蚁女王",
          "che_jian_ding" => "车鉴定"
        }
        origin_list.fetch(origin, "未知")
      end
  end
end
