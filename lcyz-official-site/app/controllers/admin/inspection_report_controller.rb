class Admin::InspectionReportController < Admin::ApplicationController

  before_action :set_car
  before_action :set_inspection_report, only: [:destroy]

  def index
    @inspection_reports = InspectionReport.where(car_id: @car.id)
  end

  def create
    record = InspectionReport.create!(inspection_report_params)
    redirect_to action: :index if record.save
  end

  def destroy
    redirect_to action: :index if @report.delete
  end

  private
    def set_car
      @car = Chelaike::CarService.find(params[:car_id], @tenant.company_id)
    end

    def set_inspection_report
      @report = InspectionReport.where(car_id: params[:car_id], id: params[:id]).first
    end

    def inspection_report_params
      params.require(:inspection_report).permit(:car_id, :report_type, :external_url, :source_link)
    end
end
