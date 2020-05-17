module V1
  class PriceTagsController < ApplicationController
    before_action :skip_authorization

    def show
      car = Car.where(company_id: current_user.company_id).find(params[:car_id])

      render json: car, serializer: CarSerializer::Common, root: "data", include: "**"
    end
  end
end
