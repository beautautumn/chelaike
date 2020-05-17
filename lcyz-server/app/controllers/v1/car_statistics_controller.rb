module V1
  class CarStatisticsController < ApplicationController
    before_action :skip_authorization, only: :show

    def overview
      param! :date, Date, default: Time.zone.today
      param! :range, String
      param! :shop_id, Integer

      range = params[:range]
      shop_id = params[:shop_id]

      authorize PunditRecord.new(CarStatisticPolicy, shop_id: shop_id, range: range)
      service = Company::CarStatisticService.new(current_user, params[:date], shop_id)

      data = case range
             when "day"
               { cars_by_day: service.cars_by_day }
             when "month"
               { cars_by_month: service.cars_by_month }
             else
               {
                 cars_by_day: service.cars_by_day,
                 cars_by_month: service.cars_by_month
               }
             end

      render json: {
        meta: { now: Time.zone.now },
        data: data
      }, scope: nil
    end

    def show
      basic_params_validations

      param! :order_field, String,
             default: "acquired_at",
             in: %w(
               id stock_age_days show_price_cents age
               mileage name_pinyin acquired_at
             )

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"
      params[:order_field] = "acquired_at" if params[:order_field] == "id"

      cars = paginate policy_scope(cars_scope)
             .ransack(params[:query]).result
             .order("#{params[:order_field]} #{order_by}")
             .order(id: :desc)

      render json: cars,
             each_serializer: CarSerializer::StatisticsList,
             root: "data"
    end

    private

    def cars_scope
      param! :type, String,
             default: "cars_acquired",
             in: %w(
               cars_acquired cars_sold cars_reserved ghost_cars
               cars_acquired_by_month cars_sold_by_month stock_by_month
               current_in_stock
             )
      param! :date, Date, default: Time.zone.today
      param! :shop_id, Integer

      Company::CarStatisticService.new(
        current_user, params[:date], params[:shop_id]
      ).public_send(params[:type])
    end
  end
end
