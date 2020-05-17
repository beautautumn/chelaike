module Dashboard
  class OldDriversController < ApplicationController
    before_action :find_order, only: [:show]

    before_action do
      authorize :dashboard_old_driver
    end

    def index
      @q = OldDriverRecord.includes(:old_driver_record_hub).all
      @q = @q.ransack(params[:q])

      @orders = @q.result
                  .includes(:old_driver_record_hub)
                  .order("created_at desc")
                  .page(params[:page])
                  .per(50)
      @counter = @q.result.count
    end

    def create
      user = ::User.find_by(username: "testmanager")
      service = ::OldDriverService::Fetch.new(user: user,
                                              vin: old_driver_params[:vin],
                                              engine_num: old_driver_params[:engine_num],
                                              license_no: old_driver_params[:license_no]
                                             )

      service.only_fetch

      redirect_to old_drivers_path
    end

    def show
      @record = OldDriverRecord.find(params[:id])
    end

    private

    def old_driver_params
      params.require(:old_driver).permit(:vin, :engine_num, :license_no, :id_numbers)
    end

    def find_order
      @order = OldDriverRecord.find(params[:id])
    end
  end
end
