module V1
  class OperationRecordsController < ApplicationController
    before_action :skip_authorization

    def alliance_cars_created_statistic
      operation_record = OperationRecord.find_by!(
        id: params[:id], operation_record_type: :alliance_cars_created_statistic
      )

      result = operation_record.messages["result"]
      return render(json: { data: [] }, scope: nil) if result.blank?

      render json: paginate(Car.where(id: result.keys.sort)),
             each_serializer: CarSerializer::AllianceCarsCreatedStatistic,
             root: "data",
             result: result
    end
  end
end
