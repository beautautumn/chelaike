module V1
  class CarPriceHistoriesController < ApplicationController
    before_action do
      authorize CarPriceHistory, :manage?
    end

    before_action :find_car

    def index
      render json: @car.car_price_histories,
             each_serializer: CarPriceHistorySerializer::Common,
             root: "data"
    end

    def create
      service = CarPriceHistory::CreateService
                .new(current_user, @car, car_price_history_params)
                .execute

      if service.valid?
        render json: service.car_price_history,
               serializer: CarPriceHistorySerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    private

    def find_car
      @car = Car.find(params[:car_id])
    end

    def car_price_history_params
      params.require(:car_price_history).permit(
        :show_price_wan, :online_price_wan, :sellable,
        :sales_minimun_price_wan, :manager_price_wan, :red_stock_warning_days,
        :alliance_minimun_price_wan, :note, :yellow_stock_warning_days,
        :new_car_guide_price_wan, :new_car_additional_price_wan,
        :new_car_discount, :new_car_final_price_wan,
        car_attributes: [:is_fixed_price]
      )
    end
  end
end
