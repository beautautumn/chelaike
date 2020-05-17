module Che3bao
  class CarsController < Che3bao::ApplicationController
    before_action :pagination_handle

    def index
      cars = paginate Car::Che3baoService.new(current_company.id, params).execute

      render json: cars,
             each_serializer: CarSerializer::Che3baoList,
             root: "rows",
             meta: {
               total: headers["X-Total"].to_i,
               totalPages: (headers["X-Total"].to_f / headers["X-Per-Page"].to_f).ceil
             }
    end

    def show
      company_ids = [current_company.id]

      if params[:company_ids]
        company_ids.concat(params[:company_ids].split(",").map(&:to_i))
      end

      car = Car.where(company_id: company_ids).find(params[:stockId])

      render json: car, serializer: CarSerializer::Che3baoDetail, root: "stockDetail"
    end

    private

    def pagination_handle
      params[:page] = params[:pageNum]
      params[:per_page] = params[:pageSize]
    end
  end
end
