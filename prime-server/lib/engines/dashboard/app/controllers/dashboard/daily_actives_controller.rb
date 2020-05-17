module Dashboard
  class DailyActivesController < ApplicationController
    skip_after_action :verify_authorized

    def index
      city = params[:city]
      start_date = params[:start_date] || Time.zone.now.to_date
      end_date = start_date

      service = ::DailyActiveService.new(start_date, end_date)

      @start_date = service.start_date
      @end_date = service.end_date
      @companies = service.valid_companies(city)
                          .page(params[:page])
                          .per(20)
      @counter = service.valid_companies(city).count
    end

    # 单个车商统计情况
    def company_dac
      company_id = params[:company_id].to_i
      start_date = params[:start_date]
      end_date   = params[:end_date]
      @company = Company.find(company_id)

      service = ::DailyActiveService.new(start_date, end_date)
      @start_date = service.start_date
      @end_date = service.end_date

      @result = service.company_dac(company_id)
    end
  end
end
