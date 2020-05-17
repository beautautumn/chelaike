module V1
  module Finance
    class CarIncomesController < ApplicationController
      before_action do
        authorize ::Finance::CarIncome
      end

      def index
        params_validation

        scope = current_company_car_incomes
                .includes(:car)
        car_incomes = paginate policy_scope(scope)
                      .ransack(params[:query]).result
        car_incomes = order_scope(car_incomes)

        render json: car_incomes,
               each_serializer: FinanceSerializer::CarIncomeSerializer::Common,
               root: "data"
      end

      def show
        @car_income = current_company_car_incomes.find(params[:id])
        render json: @car_income,
               serializer: FinanceSerializer::CarIncomeSerializer::Common,
               root: "data"
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def export
        params_validation

        scope = current_company_car_incomes
                .includes(:car)
        car_incomes = policy_scope(scope)
                      .ransack(params[:query]).result

        car_incomes = order_scope(car_incomes)

        title = %w(
          库存号 车辆名称 车架号 销售员 出库日期 收购员 收购日期 收购类型
          入库价 入库付款 整备费用 手续费 佣金 提成／分成 资金费用 其它成本
          出库价 出库收款 其它收益 毛利 毛利率 净利 净利率
        )

        format = car_incomes.map do |r|
          [
            r.car.stock_number,
            r.car.system_name,
            r.car.vin,
            r.car.try(:seller).try(:name),
            r.car.try(:stock_out_at).try { |d| d.strftime("%Y-%m-%d") },
            r.car.try(:acquirer).try(:name),
            r.car.try(:acquired_at).try { |d| d.strftime("%Y-%m-%d") },
            I18n.t("enumerize.car.acquisition_type.#{r.car.acquisition_type}"),
            r.acquisition_price_wan,
            r.payment_wan,
            r.prepare_cost_yuan,
            r.handling_charge_yuan,
            r.commission_yuan,
            r.percentage_yuan,
            r.fund_cost_yuan,
            r.other_cost_yuan,

            r.closing_cost_wan,
            r.receipt_wan,
            r.other_profit_yuan,
            r.gross_profit,
            r.gross_margin,
            r.net_profit,
            r.net_margin
          ]
        end

        name = "单车成本与收益报表#{Time.zone.now.strftime("%Y%m%d")}.xls"

        headers["Cache-Control"] = "no-cache"
        headers["Content-Type"] = "text/event-stream; charset=utf-8"
        headers["Content-disposition"] = "attachment; filename=\"#{name}\""
        headers["X-Accel-Buffering"] = "no"
        headers.delete("Content-Length")

        self.response_body = HoneySheet::Excel.package(name, title, format)
      end

      # 修改入库/出库价格
      # 考虑到以后可能需要更详细的权限, 写成单独的接口
      def update_price
        param! :type, String, in: %w(in_stock out_stock)

        car = current_company_car_incomes.find(params[:id]).car
        type = params[:type].to_s

        service = Car::UpdatePriceService.new(
          current_user, car
        )

        result = case type
                 when "in_stock"
                   service.in_stock(in_stock_price_params)
                 when "out_stock"
                   service.out_stock(out_stock_price_params, stock_out_inventory_params)
                 end

        if result.valid?
          render json: result.finance_car_income,
                 serializer: FinanceSerializer::CarIncomeSerializer::Common,
                 root: "data"
        else
          validation_error(result.errors)
        end
      end

      def update_fund_rate
        @car_income = current_company_car_incomes.find(params[:id])
        if @car_income.update(fund_rate_params)
          service = FinanceService::CarFees.new(current_user, @car_income.car)
          service.generate_monthly_fund_cost
          render json: @car_income.reload,
                 serializer: FinanceSerializer::CarIncomeSerializer::Common,
                 root: "data"
        else
          validation_error(@car_income)
        end
      end

      private

      def order_scope(car_incomes)
        order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"
        car_incomes.order("cars.#{params[:order_field]} #{order_by}")
      end

      def params_validation
        basic_params_validations
        param! :order_field, String,
               default: "stock_out_at",
               in: %w(acquired_at stock_out_at)
      end

      def current_company_car_incomes
        ::Finance::CarIncome
          .where(company_id: current_user.company_id)
      end

      def in_stock_price_params
        params.require(:finance_car_income)
              .permit(:shop_id, :acquirer_id, :acquired_at, :acquisition_price_wan, :note)
      end

      def out_stock_price_params
        params.require(:finance_car_income)
              .permit(:note, :closing_cost_wan)
      end

      def stock_out_inventory_params
        V1::StockOutInventories::StockOutInventoryFilter.new(params).execute
      end

      def fund_rate_params
        params.require(:finance_car_income).permit(:fund_rate, :loan_wan)
      end
    end
  end
end
