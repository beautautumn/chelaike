module V1
  class AllianceCarsController < ApplicationController
    before_action :find_alliance

    def index
      authorize @alliance, :cars?

      basic_params_validations
      param! :order_field, String, default: "id",
                                   in: %w(id show_price_cents age mileage acquired_at)

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

      cars = paginate @alliance.allowed_cars
             .eager_load_bunch_data
             .state_in_stock_scope
             .where(reserved: false)
             .ransack(params[:query])
             .result
             .distinct
             .order("#{params[:order_field]} #{order_by}")
             .order(:id)

      render json: cars,
             each_serializer: CarSerializer::Alliance,
             root: "data"
    end

    private

    def find_alliance
      @alliance = Company.find(current_user.company_id).alliances
                         .find(params[:alliance_id])
    end
  end
end
