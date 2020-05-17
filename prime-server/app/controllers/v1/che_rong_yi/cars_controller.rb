# 新版车容易里需要的接口
module V1
  module CheRongYi
    class CarsController < ApplicationController
      before_action do
        authorize Car
      end

      # 得到所有本车商里未被质押车辆列表
      def index
        basic_params_validations

        scope = cars_scope.where(loan_status: [nil, :noloan]).includes(
          :acquisition_transfer, :shop, :acquirer, :cover,
          :car_reservation
        )

        cars = paginate scope.ransack(params[:query]).result

        render json: cars,
               each_serializer: CarSerializer::InStockList,
               root: "data"
      end

      private

      def cars_scope
        Car.where(company_id: current_user.company_id).state_in_stock_scope
      end
    end
  end
end
