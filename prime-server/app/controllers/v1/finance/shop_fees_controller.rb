module V1
  module Finance
    class ShopFeesController < ApplicationController
      before_action do
        authorize ::Finance::CarIncome
      end

      def index
        render json: statistic_data,
               each_serializer: FinanceSerializer::ShopFeeSerializer::Common,
               root: "data"
      end

      def update
        shop_fee = policy_scope(::Finance::ShopFee.find(params[:id]))
        shop_fee.update(shop_fee_params)

        if shop_fee.errors.empty?
          car_fees = ::Finance::CarFee.by_month(shop_fee.shop_id, shop_fee.month)
          car_fees.each do |fee|
            compute_car_fee(shop_fee, fee)
          end

          render json: shop_fee,
                 serializer: FinanceSerializer::ShopFeeSerializer::Common,
                 root: "data"
        else
          validation_error(full_errors(shop_fee))
        end
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def export
        shop_fees = statistic_data
        title = %w(
          年月 车辆成本（万元） 场租（元） 固定工资（元）
          社保／公积金（元） 奖金／福利（元）市场营销（元）
          水电（元） 办公用品（元） 通讯费（元） 其它费用（元）
          销售收入（万元） 其它收入（元）
          毛利（万元） 毛利率 净利（万元） 净利率 备注
        )

        format = shop_fees.map do |r|
          [
            r.month,
            r.car_cost_wan,
            r.location_rent_yuan,
            r.salary_yuan,
            r.social_insurance_yuan,
            r.bonus_yuan,
            r.marketing_expenses_yuan,
            r.energy_fee_yuan,
            r.office_fee_yuan,
            r.communication_fee_yuan,
            r.other_cost_yuan,

            r.sales_revenue_wan,
            r.other_profit_yuan,

            r.gross_profit,
            r.gross_margin,
            r.net_profit,
            r.net_margin,
            r.note
          ]
        end

        name = "运营成本与收益报表#{Time.zone.now.strftime("%Y%m%d")}.xls"

        headers["Cache-Control"] = "no-cache"
        headers["Content-Type"] = "text/event-stream; charset=utf-8"
        headers["Content-disposition"] = "attachment; filename=\"#{name}\""
        headers["X-Accel-Buffering"] = "no"
        headers.delete("Content-Length")

        self.response_body = HoneySheet::Excel.package(name, title, format)
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      private

      def statistic_data
        basic_params_validations

        shop_id = params[:query][:shop_id]

        shop_fees = policy_scope(::Finance::ShopFee.recent(shop_id))

        unless shop_fees.empty?
          start_at = Time.zone.parse(shop_fees.last.month + "-01")
          shop_fees_hash = {}.tap { |x| shop_fees.each { |fee| x[fee.month] = fee } }

          count_fee_amount(shop_fees_hash, shop_id, start_at)
        end

        shop_fees
      end

      def count_fee_amount(shop_fees_hash, shop_id, start_at)
        car_fees = ::Finance::CarFee.occur_start(shop_id, start_at)
        car_fees.each do |fee|
          month = fee.fee_date.strftime "%Y-%m"
          next unless shop_fees_hash.key? month
          shop_fee = shop_fees_hash[month]
          compute_car_fee(shop_fee, fee)
        end
      end

      def compute_car_fee(shop_fee, car_fee)
        if car_fee.profit?
          shop_fee.add_profit(car_fee.amount_cents)
        else
          shop_fee.add_cost(car_fee.amount_cents)
        end
      end

      def shop_fee_params
        params.require(:finance_shop_fee).permit(
          :location_rent_yuan, :salary_yuan, :social_insurance_yuan,
          :bonus_yuan, :marketing_expenses_yuan, :energy_fee_yuan,
          :office_fee_yuan, :communication_fee_yuan, :other_cost_yuan,
          :other_profit_yuan, :note)
      end
    end
  end
end
