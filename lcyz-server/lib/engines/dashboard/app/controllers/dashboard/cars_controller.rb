module Dashboard
  class CarsController < ApplicationController
    before_action do
      authorize :dashboard_car
    end

    def show
      render json: Car.find(params[:id]),
             serializer: CarDetail,
             root: "data", include: "**"
    end
  end
end
