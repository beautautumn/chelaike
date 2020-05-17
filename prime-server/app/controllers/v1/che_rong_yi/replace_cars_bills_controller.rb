# 新版车容易换车单相关接口
module V1
  module CheRongYi
    class ReplaceCarsBillsController < ApplicationController
      before_action do
        authorize ::CheRongYi::ReplaceCarsBill
      end

      def index
      end

      # 创建换车单
      def create
        replace_cars_bill_params = {
          loan_bill_id: params[:loan_bill_id],
          will_replace_car_ids: params[:will_replace_car_ids], # 要替换上来的车辆id
          is_replaced_car_ids: params[:is_replaced_car_ids], # 被替换下去的车辆
          no_replace_car_ids: params[:no_replace_car_ids], # 未被替换的原车辆
          user_id: current_user.id,
          shop_id: current_user.company_id
        }

        result_data = ::CheRongYi::Api.create_replace_cars_bill(
          replace_cars_bill_params
        )

        Car.where(id: params[:will_replace_car_ids]).update_all(
          loan_status: :loan,
          loan_bill_id: params[:loan_bill_id]
        )

        render json: { data: result_data }, scope: nil
      rescue ::CheRongYi::Api::RequestError => e
        validation_error({}, message: e.message)
      end

      def show
        replace_cars_bill = ::CheRongYi::Api.replace_cars_bill(params[:id])

        render json: replace_cars_bill,
               serializer: CheRongYiSerializer::ReplaceCarsBillSerializer::Detail,
               root: "data"
      rescue ::CheRongYi::Api::RequestError => e
        validation_error({}, message: e.message)
      end
    end
  end
end
