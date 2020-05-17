module V1
  class DetectionReportsController < ApplicationController
    before_action :set_car

    def show
      report = @car.detection_report

      authorize DetectionReport

      if report
        render json: report,
               serializer: DetectionReportSerializer::Detail,
               root: "data"
      else
        render json: { data: nil }
      end
    end

    def create
      report = @car.create_detection_report!(
        detection_params
      )

      authorize report

      render json: report,
             serializer: DetectionReportSerializer::Detail,
             root: "data"
    end

    def update
      report = @car.detection_report

      report.update!(
        detection_params
      )

      authorize report

      render json: report,
             serializer: DetectionReportSerializer::Detail,
             root: "data"
    end

    private

    def detection_params
      params.require(:detection_report).permit(
        :report_type, :url,
        images: [:id, :url, :sort, :_destroy]
      ).tap do |white_listed|
        if white_listed[:images].present?
          white_listed[:images_attributes] = white_listed[:images]
          white_listed.delete(:images)
        end
        white_listed
      end
    end

    def set_car
      @car = Car.find(params[:car_id])
    end
  end
end
