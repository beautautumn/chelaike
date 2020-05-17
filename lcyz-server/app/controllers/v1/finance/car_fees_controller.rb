module V1
  module Finance
    class CarFeesController < ApplicationController
      before_action :find_car
      before_action do
        authorize ::Finance::CarIncome
      end

      def index
        category = params[:category]

        car_fees = @car.finance_car_fees
                       .where(category: category)
                       .order("fee_date DESC, id DESC")

        render json: car_fees,
               each_serializer: FinanceSerializer::CarFeeSerializer::Common,
               root: "data",
               meta: {
                 car_id: @car.id,
                 car_name: @car.try(:name),
                 acquisition_price_wan: @car.try(:acquisition_price_wan),
                 loan_wan: @car.try(:loan_wan)
               }
      end

      # 同时处理添加，删除，修改某条费用项目记录
      def batch_update
        service = FinanceService::CarFees.new(current_user, @car)
        service = service.batch_update(params[:car_fees])

        if service.valid?
          render json: @car.finance_car_income.reload,
                 serializer: FinanceSerializer::CarIncomeSerializer::Common,
                 root: "data"
        else
          validation_error(service.errors)
        end
      end

      # 入库付款
      def payment
        payment = @car.finance_car_fees.payment
        paid = payment.map(&:amount_wan).sum
        render json: payment,
               each_serializer: FinanceSerializer::CarFeeSerializer::Common,
               root: "data",
               meta: {
                 car_id: @car.id,
                 car_name: @car.try(:name),
                 payable: @car.finance_car_income.acquisition_price_wan,
                 paid: paid
               }
      end

      # 出库收款
      def receipt
        receipt = @car.finance_car_fees.receipt
        received = receipt.map(&:amount_wan).sum
        render json: receipt,
               each_serializer: FinanceSerializer::CarFeeSerializer::Common,
               root: "data",
               meta: {
                 car_id: @car.id,
                 car_name: @car.try(:name),
                 receivable: @car.finance_car_income.closing_cost_wan,
                 received: received
               }
      end

      private

      def find_car
        @car = Car.find(params[:car_id])
      end
    end
  end
end
