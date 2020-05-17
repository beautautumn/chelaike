# 新版车容易接口，主要逻辑交给对应java端去处理
module V1
  module CheRongYi
    class LoanBillsController < ApplicationController
      before_action do
        authorize EasyLoan::LoanBill
      end

      def index
        query = params.fetch(:query, {})
        request_params = {
          page: params[:page].to_i - 1, per_page: params[:per_page],
          funder_company_id: query[:funder_company_id],
          brand_name: query[:brand_name],
          shop_id: current_user.company_id,
          state: query[:state],
          replace_history: query[:replace_history]
        }

        result = ::CheRongYi::Api.loan_bills(request_params)

        loan_bills = result.fetch(:loan_bills)

        response.headers["X-Total"] = result[:total_count]
        response.headers["X-Per-Page"] = result[:per_page]

        render json: loan_bills,
               each_serializer: CheRongYiSerializer::LoanBillSerializer::Common,
               root: "data"
      rescue ::CheRongYi::Api::RequestError => e
        validation_error(e.message, message: e.message)
      end

      def show
        loan_bill = ::CheRongYi::Api.loan_bill(params[:id])

        render json: loan_bill,
               serializer: CheRongYiSerializer::LoanBillSerializer::Detail,
               root: "data"
      rescue ::CheRongYi::Api::RequestError => e
        validation_error(e.message, message: e.message)
      end

      def create
        # car_ids, funder_company_id, estimate_borrow_amount_wan
        result_data = ::CheRongYi::Api.create_loan_bill(
          car_ids: params[:car_ids], shop_id: current_user.company_id,
          funder_company_id: params[:funder_company_id],
          estimate_borrow_amount_cents: (params[:estimate_borrow_amount_wan].to_d * 1_000_000).to_i
        )

        Car.where(id: params[:car_ids]).update_all(
          loan_status: :loan,
          loan_bill_id: result_data[:loan_bill_id]
        )
        render json: { data: result_data }, scope: nil
      rescue ::CheRongYi::Api::RequestError => e
        validation_error(e.message, message: e.message)
      end

      def update
      end

      # 检测车辆信息后返回金融机构信息
      def post_check
        company_id = current_user.company_id

        # car_ids = params[:car_ids]

        # total_estimate_price_wan = Car.where(id: car_ids).inject(0) do |sum, car|
        #   sum + car.estimate_price_wan.to_d
        # end

        accredited_records = ::CheRongYi::Api.loan_accredited_records(company_id)

        infos = accredited_records.map do |record|
          {
            funder_company_id: record.funder_company_id, # 资金公司ID
            funder_company_name: record.funder_company_name, # 资金公司名
            limit_amount_wan: record.limit_amount_wan, # 授信总额度
            in_use_amount_wan: record.in_use_amount_wan, # 已使用额度
            unused_amount_wan: record.limit_amount_wan - record.in_use_amount_wan, # 未用额度
            current_credit_wan: record.current_credit_wan,
            estimate_amount_wan: 0
          }
        end

        render json: { data: infos }, scope: nil
      end

      # 还款
      # 这个接口没有被用到
      def repay
        # params[:repay_car_ids]
        # params[:remaining_car_ids]
        # params[:repay_amount_wan] # 本次还款金额

        loan_bill_service = ::CheRongYi::LoanBillService.new(params[:id])

        result = loan_bill_service.repay(
          remaining_car_ids: params[:remaining_car_ids],
          repay_car_ids: params[:repay_car_ids],
          repay_amount_wan: params[:repay_amount_wan]
        )

        if result.status
          repayment_bill = result.data
          render json: repayment_bill,
                 serializer: CheRongYiSerializer::RepaymentBillSerializer::Common,
                 root: "data"
        else
          validation_error("还款申请失败，剩余车辆估值可借款金额小于剩余借款金额，请修改还款金额")
        end
      end
    end
  end
end
