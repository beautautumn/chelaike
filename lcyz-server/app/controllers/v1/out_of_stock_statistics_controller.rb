module V1
  class OutOfStockStatisticsController < ApplicationController
    before_action do
      param! :date, Date, default: Time.zone.today
      param! :range, String, default: "day"
      param! :shop_id, Integer

      authorize PunditRecord.new(OutOfStockStatisticPolicy, shop_id: params[:shop_id])
    end

    def stock_out_modes
      render json: {
        data: out_of_stock_info(Dw::Analysis::StockOutMode)
      }, scope: nil
    end

    def closing_costs
      render json: {
        data: out_of_stock_info(Dw::Analysis::ClosingCost)
      }, scope: nil
    end

    def ages
      render json: {
        data: out_of_stock_info(Dw::Analysis::Age)
      }, scope: nil
    end

    def brands
      render json: {
        data: out_of_stock_info(Dw::Analysis::Brand)
      }, scope: nil
    end

    def series
      render json: {
        data: out_of_stock_info(Dw::Analysis::Series)
      }, scope: nil
    end

    def appraisers
      info = out_of_stock_info(Dw::Analysis::User)

      response_data = {
        data: info.fetch(:detail),
        meta: {
          sumup: info.fetch(:sumup),
          other_users: info.fetch(:other_users)
        }
      }

      render json: response_data, scope: nil
    end

    def sellers
      analysis = Dw::Analysis::User.new(
        current_user.company_id, shop_id: params[:shop_id]
      )
      info = analysis.out_of_stock_info(
        analysis.stock_out_at_conditions(params[:date], params[:range]),
        target: :seller
      )

      response_data = {
        data: info.fetch(:detail),
        meta: {
          sumup: info.fetch(:sumup),
          other_users: info.fetch(:other_users)
        }
      }

      render json: response_data, scope: nil
    end

    def stock_ages
      render json: {
        data: out_of_stock_info(Dw::Analysis::StockAge)
      }, scope: nil
    end

    private

    def out_of_stock_info(klass)
      analysis = klass.new(current_user.company_id, shop_id: params[:shop_id])

      analysis.out_of_stock_info(
        analysis.stock_out_at_conditions(params[:date], params[:range])
      )
    end
  end
end
