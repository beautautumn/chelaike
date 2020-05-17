module Dashboard
  class OrdersController < ApplicationController
    helper_method :get_state_name

    before_action do
      authorize :dashboard_order
    end

    def index
      @q = Order.all
      if params.key?(:province_cond) && !params[:province_cond].empty?
        company_ids = Company.where("province like ?", "%#{params[:province_cond]}%")
                          .collect{|r| r.id}
        @q = @q.where("company_id IN (?)", company_ids)
      end
      if params.key?(:city_cond) && !params[:city_cond].empty?
        company_ids = Company.where("city like ?", "%#{params[:city_cond]}%")
                          .collect{|r| r.id}
        @q = @q.where("company_id IN (?)", company_ids)
      end
      if params.key?(:company_name_cond) && !params[:company_name_cond].empty?
        company_ids = Company.where("name like ?", "%#{params[:company_name_cond]}%")
                          .collect{|r| r.id}
        @q = @q.where("company_id IN (?)", company_ids)
      end
      staff_id = params[:staff_id]
      if staff_id && !staff_id.empty?
        company_ids = CompanyProperty.where(staff_id: staff_id).collect{|r| r.company_id}
        @q = @q.where("company_id IN (?)", company_ids)
      end

      @q = @q.ransack(params[:q])
      @orders = @q.result
                 .order("created_at desc")
                 .page(params[:page])
                 .per(20)
      @counter = @q.result.count
    end

    private
      def get_state_name (status)
        status_list = {
          "init" => "新建",
          "charge" => "充值中",
          "success" => "成功"
        }
        status_list.fetch(status, "未知")
      end
  end
end
