module V1
  class StatisticsController < ApplicationController
    before_action :skip_authorization

    def company
      render json: {
        meta: {
          now: Time.zone.now
        },
        data: Company::StatisticService.new(current_user.company, current_user).execute
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

      cars = paginate policy_scope(cars_acquired_scope)
             .ransack(params[:query]).result
             .order("#{params[:order_field]} #{order_by}")
             .order(id: :desc)

      render json: cars,
             each_serializer: CarSerializer::StatisticsList,
             root: "data"
    end

    private

    def cars_acquired_scope
      param! :type, String,
             default: "cars_sold_today",
             in: %w(
               cars_sold_today cars_reserved_today ghost_cars cars_acquired_today
               cars_sold_current_month cars_acquired_current_month cars_in_stock
             )

      Company::StatisticService.new(current_user.company, current_user)
                               .public_send(params[:type])
    end
  end
end
