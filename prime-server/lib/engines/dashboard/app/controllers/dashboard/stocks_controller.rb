module Dashboard
  class StocksController < ApplicationController
    helper_method :build_name, :acquisition_type_name

    before_action do
      authorize :dashboard_stock
    end

    def index
      stock_id = params[:stock_id]
      if stock_id && !stock_id.empty?
        @q = Car.where(id: stock_id)
      else
        @q = Car.all
      end
      @q = @q.state_in_stock_scope.ransack(params[:q])
      @cars = @q.result
                 .includes(:company, :acquirer)
                 .order("acquired_at desc NULLS LAST")
                 .order("id desc")
                 .page(params[:page])
                 .per(20)
      @counter = @q.result.count
    end

    private

      def build_name(car)
        car.try(:brand_name).to_s + " " + car.try(:series_name).to_s + " " + car.try(:style_name).to_s
      end

      def acquisition_type_name(acquisition_type)
        case acquisition_type
          when :acquisition
            "收购"
          when :consignment
            "寄卖"
          when :cooperation
            "合作"
          when :permute
            "置换"
          else
            "收购"
          end
      end
  end
end
