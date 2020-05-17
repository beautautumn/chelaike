# 还款单相关
module V1
  module CheRongYi
    class RepaymentBillsController < ApplicationController
      before_action do
        authorize ::CheRongYi::RepaymentBill
      end

      # 申请还款
      def apply
        repayment_bill = ::CheRongYi::Api.repayment_apply(params[:loan_bill_id])

        render json: repayment_bill,
               serializer: CheRongYiSerializer::RepaymentBillSerializer::Detail,
               root: "data"
      rescue ::CheRongYi::Api::RequestError => e
        validation_error(e.message, message: e.message)
      end

      def index
      end

      def create
        repayment_bill_params = {
          loan_bill_id: params[:loan_bill_id],
          car_ids: params[:car_ids],
          repayment_amount_wan: params[:repayment_amount_wan]
        }

        result_data = ::CheRongYi::Api.create_repayment_bill(
          repayment_bill_params
        )

        render json: { data: result_data }, scope: nil
      rescue ::CheRongYi::Api::RequestError => e
        validation_error(e.message, message: e.message)
      end

      def show
        repayment_bill = ::CheRongYi::Api.repayment_bill(params[:id])

        render json: repayment_bill,
               serializer: CheRongYiSerializer::RepaymentBillSerializer::Detail,
               root: "data"
      rescue ::CheRongYi::Api::RequestError => e
        validation_error(e.message, message: e.message)
      end
    end
  end
end
