module Market
  class CarsController < ApplicationController
    before_action :skip_authorization

    def index
      cars = paginate Car.where(company_id: current_user.company_id)
             .ransack(params[:conditions]).result

      render json: cars.eager_load_bunch_data,
             each_serializer: CarSerializer::Common,
             root: "data", include: "**"
    end
  end
end
