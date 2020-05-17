# frozen_string_literal: true
module Admin
  class InsuranceRecordsController < ApplicationController
    def create
      car = Chelaike::CarService.find(params[:car_id], nil)

      insurance_record = InsuranceRecord.new(insurance_record_params)

      if insurance_record.save
        redirect_to admin_cars_path, notice: "#{car.name} 的保险理赔报告已导入"
      else
        redirect_to new_admin_car_insurance_record_path(car_id), notice: "报告导入失败"
      end
    end

    # 展示
    def show; end

    def new
      car_id = params[:car_id]

      @car = Chelaike::CarService.find(car_id, nil)
      if params[:import_report]
        new_with_imported(car_id)
      else
        @insurance_record = InsuranceRecord.where(car_id: @car.id).last
        @insurance_record ||= InsuranceRecord.new(
          car_id: car_id, vin: "", mileage: "",
          total_records_count: 0, claims_abstract: {},
          record_abstract: {}, claims_details: [],
          make: "", order_id: ""
        )
      end
    end

    private

    def new_with_imported(car_id)
      result = Chelaike::CarService.insurance_record(car_id)

      if result.nil?
        redirect_to new_admin_car_insurance_record_path(car_id), notice: "没有相应报告，请联系管理员进行查询"
      else
        @insurance_record = result.fetch(:insurance_record)
        render "new"
      end
    end

    def insurance_record_params
      params.require(:insurance_record).permit(
        :car_id, :order_id, :make, :vin, :total_records_count,
        :mileage, :claims_count,
        { record_abstract: [:latest_record_time, :used_type,
                            :made_year, :mileage_record, :emission_standard] },
        { claims_abstract: [{ periods: [:dates, :claims_count] }, :total_lose_amount] },
        claims_details: [:claim_date, :claim_mileage, :lobor_fee,
                         :accident_type, :description, :repair_detail,
                         :material]
      ).tap do |white_listed|
        white_listed[:claims_total_fee_yuan] = params[:insurance_record].fetch(:claims_abstract)
                                                                        .fetch(:total_lose_amount)
      end
    end
  end
end
