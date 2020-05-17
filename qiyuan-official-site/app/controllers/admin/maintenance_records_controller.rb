# frozen_string_literal: true

module Admin
  class MaintenanceRecordsController < ApplicationController
    def new
      @car = Chelaike::CarService.find(params[:car_id], @tenant.company_id)
      @maintenance_record = MaintenanceRecord.find_or_initialize_by(car_id: params[:car_id])
    end

    def import
      @to_be_imported = Chelaike::CarService.maintenance_detail(params[:car_id], @tenant.company_id)
      render json: @to_be_imported
    end

    def create
      @maintenance_record = MaintenanceRecord.find_or_create_by(car_id: params[:car_id])
      @maintenance_record.update(maintenance_record_params)
      redirect_to admin_cars_path
    end

    private

    def maintenance_record_params
      params.require(:maintenance_record)
            .permit(:car_name, :vin, :last_date, :mileage,
                    :new_car_warranty, :emission_standard,
                    record_abstract: %i[
                      summary last_record_mileage
                      last_record_date
                      ab en mi tr sd fire water
                    ],
                    record_detail: [:category, :date, :mileage, :item, :material])
    end
  end
end
