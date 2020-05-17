module Dashboard
  class SalesController < ApplicationController
    helper_method :build_name, :stock_out_inventory_type, :sales_type

    before_action do
      authorize :dashboard_sale
    end

    def index
      stock_id = params[:stock_id]
      if stock_id && !stock_id.empty?
        @q = StockOutInventory.where(car_id: stock_id)
      else
        @q = StockOutInventory.all
      end
      @q = @q.ransack(params[:q])
      @sales = @q.result
                 .includes({ car: [:company, :acquirer] }, :seller)
                 .where(current: true)
                 .order("completed_at desc NULLS LAST")
                 .order("id desc")
                 .page(params[:page])
                 .per(20)
      @counter = @q.result.where(current: true).count
    end

    protected

    def build_name(car)
      car.try(:brand_name).to_s + " " + car.try(:series_name).to_s + " " + car.try(:style_name).to_s
    end

    def stock_out_inventory_type(sale)
      case sale.stock_out_inventory_type
      when "sold"
        "销售出库"
      when "acquisition_refunded"
        "收购退车"
      when "driven_back"
        "车主开回"
      else
        ""
      end
    end

    def sales_type(sale)
      case sale.sales_type
      when "retail"
        "零售"
      when "wholesale"
        "批发"
      else
        ""
      end
    end
  end
end
