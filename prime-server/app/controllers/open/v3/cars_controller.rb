# 处理车容易通知过来改变车辆状态
module Open
  module V3
    class CarsController < V3::ApplicationController
      before_action :find_car

      # 更改车辆融资状态
      def update
        @car.update!(car_params)

        render json: @car,
               serializer: CarSerializer::Mini,
               root: "data"
      end

      private

      def car_params
        params.require(:car).permit(:id, :loan_status)
      end

      def find_car
        @car = Car.find(params[:id])
      end
    end
  end
end
