module V1
  class CarStateHistoriesController < ApplicationController
    before_action do
      authorize CarStateHistory, :manage?
    end
    before_action :find_car

    def create
      service = CarStateHistory::CreateService
                .new(current_user, @car, car_state_history_params)
                .execute
      car_state_history = service.car_state_history

      if service.valid?
        render json: car_state_history,
               serializer: CarStateHistorySerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    private

    def find_car
      @car = Car.find(params[:car_id])
    end

    def car_state_history_params
      params.require(:car_state_history).permit(
        :sellable, :state, :occurred_at, :note, :predicted_restocked_at
      )
    end
  end
end
