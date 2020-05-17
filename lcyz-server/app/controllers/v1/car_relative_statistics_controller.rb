module V1
  class CarRelativeStatisticsController < ApplicationController
    before_action :skip_authorization

    def show
      param! :type, String,
             default: "intentions",
             in: %w(intentions checked_intentions similar_in_stock similar_sold)

      send(params[:type])
    end

    def sumup
      render json: { data: service.execute }, scope: nil
    end

    private

    def current_car
      Car.find(params[:car_id])
    end

    def service
      Car::RelativeStatisticService.new(current_user, current_car)
    end

    def intentions
      intentions = service.intentions.includes(
        :intention_level, :channel, :assignee,
        :source_company, :source_car, :closing_car,
        latest_intention_push_history: [
          :intention_level, :executor, :closing_car,
          { cars: [:cover] }
        ]
      )

      render json: paginate(intentions),
             each_serializer: IntentionSerializer::Common,
             root: "data", include: "**"
    end

    def checked_intentions
      checked_intentions = service.checked_intentions.includes(
        intention: [:intention_level, :assignee]
      )

      render json: paginate(checked_intentions),
             each_serializer: IntentionPushCarSerializer::Common,
             root: "data", include: "**"
    end

    def similar_in_stock
      cars = service.similar_in_stock
                    .order("cars.id desc")
                    .includes(
                      :acquisition_transfer, :shop, :acquirer, :cover, :car_reservation
                    )

      render json: paginate(cars),
             each_serializer: CarSerializer::InStockList,
             root: "data"
    end

    def similar_sold
      cars = service.similar_sold
                    .order("cars.id desc, cars.updated_at desc")
                    .includes(
                      { stock_out_inventory: [:seller, :operator] },
                      :cover, :acquirer, :shop, :acquisition_transfer
                    )

      render json: paginate(cars),
             each_serializer: CarSerializer::OutOfStockList,
             root: "data",
             include: "**"
    end
  end
end
