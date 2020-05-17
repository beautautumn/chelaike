module V1
  class DailyReportsController < ApplicationController
    before_action :skip_authorization

    def show
      param! :page, Integer, default: 1
      param! :per_page, Integer, default: 25

      operation_record = OperationRecord.find(params[:id])
      car_ids = operation_record.messages.fetch(params[:type], [])

      cars = paginate Car.with_deleted
             .where(company_id: current_user.company_id)
             .where(id: car_ids)

      render json: cars.eager_load_bunch_data,
             each_serializer: CarSerializer::DailyReport,
             root: "data"
    end
  end
end
