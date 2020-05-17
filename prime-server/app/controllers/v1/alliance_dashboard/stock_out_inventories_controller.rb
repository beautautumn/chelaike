module V1
  module AllianceDashboard
    class StockOutInventoriesController < V1::AllianceDashboard::ApplicationController
      before_action do
        authorize StockOutInventory
      end

      before_action :find_car

      def show
        if @car.stock_out_inventory
          render json: @car.stock_out_inventory,
                 serializer: StockOutInventorySerializer::Common,
                 root: "data"
        else
          render json: { data: {} }, scope: nil
        end
      end

      private

      def find_car
        @car = Car.find(params[:car_id])
      end
    end
  end
end
