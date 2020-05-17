module V1
  class AcquiredCarStatisticsController < ApplicationController
    before_action do
      param! :date, Date, default: Time.zone.today
      param! :range, String, default: "day", in: %w(day month)
      param! :stock_by_month, :boolean, default: false
      param! :current_in_stock, :boolean, default: false
      param! :shop_id, Integer

      authorize PunditRecord.new(AcquiredCarStatisticPolicy, shop_id: params[:shop_id])
    end

    def acquirers
      info = stock_info(Dw::Analysis::User)

      response_data = {
        meta: {
          acquisition_types: info.fetch(:acquisition_types),
          total_acquisition_amount: info.fetch(:total_acquisition_amount),
          other_users: info.fetch(:other_users)
        },
        data: info.fetch(:detail)
      }

      render json: response_data, scope: nil
    end

    def brands
      render json: {
        data: stock_info(Dw::Analysis::Brand)
      }, scope: nil
    end

    def series
      render json: {
        data: stock_info(Dw::Analysis::Series)
      }, scope: nil
    end

    def ages
      render json: {
        data: stock_info(Dw::Analysis::Age)
      }, scope: nil
    end

    def estimated_gross_profits
      render json: {
        data: stock_info(Dw::Analysis::EstimatedGrossProfit)
      }, scope: nil
    end

    def acquisition_prices
      render json: {
        data: stock_info(Dw::Analysis::AcquisitionPrice)
      }, scope: nil
    end

    def acquisition_types
      render json: {
        data: stock_info(Dw::Analysis::AcquisitionType)
      }, scope: nil
    end

    def stock_ages
      render json: {
        data: stock_info(Dw::Analysis::StockAge)
      }, scope: nil
    end

    private

    def stock_info(klass)
      analysis = klass.new(current_user.company_id, shop_id: params[:shop_id])

      date = params[:date]
      range = params[:range]

      if params[:stock_by_month]
        analysis.stock_info(car_id_in: analysis.stock_by_month_car_ids(date) + [-1])
      elsif params[:current_in_stock]
        analysis.stock_info(car_id_in: analysis.current_in_stock_car_ids + [-1])
      else
        analysis.stock_info(analysis.acquired_at_conditions(date, range))
      end
    end
  end
end
