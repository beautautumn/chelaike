module V1
  class AllianceStockOutInventoriesController < ApplicationController
    before_action except: :show do
      authorize AllianceStockOutInventory
    end

    before_action :validate_param!, only: [:create, :update]
    before_action :find_car
    before_action V1::AllianceStockOutInventories::AllianceStockOutInventoryFilter, except: :show

    def show
      inventory = @car.alliance_stock_out_inventory
      if inventory
        authorize inventory, :show?

        render json: inventory,
               serializer: AllianceStockOutInventorySerializer::Contract,
               root: "data"
      else
        render json: { data: {} }, scope: nil
      end
    end

    def create
      service = Car::AllianceStockOutService.new(user: current_user,
                                                 car: @car,
                                                 params: @output_params
                                                  .merge(from_company_id: @car.company_id))
                                            .create

      if service.valid?
        render json: { data: service.alliance_stock_out_inventory }, scope: nil
      else
        validation_error(service.errors)
      end
    end

    def update
      service = Car::AllianceStockOutService.new(user: current_user,
                                                 new_car: @car,
                                                 params: @output_params)
                                            .update

      if service.valid?
        render json: { data: service.alliance_stock_out_inventory }, scope: nil
      else
        validation_error(service.errors)
      end
    end

    private

    def find_car
      @car = Car.find(params[:car_id])
    end

    def validate_param!
      param! :alliance_stock_out_inventory, Hash, required: true do |h|
        if params[:action] == "update"
          h.param! :refunded_price_wan, Float, required: true
          h.param! :refunded_at, Date, required: true
        end
      end
    end
  end
end
