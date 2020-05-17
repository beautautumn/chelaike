module V1
  class StockOutInventoriesController < ApplicationController
    before_action do
      authorize StockOutInventory
    end

    before_action :validate_param!, only: [:create, :update]
    before_action :find_car
    before_action V1::StockOutInventories::StockOutInventoryFilter, except: :show

    def create
      if params[:stock_out_inventory][:stock_out_inventory_type] == "alliance"
        alliance_stock_out
      elsif params[:stock_out_inventory][:stock_out_inventory_type] == "alliance_refunded"
        alliance_refund
      else
        stock_out
      end
    end

    def update
      service = Car::StockOutService.new(
        current_user, @car, @output_params
      ).update

      stock_out_inventory = service.stock_out_inventory

      if service.valid?
        render json: stock_out_inventory,
               serializer: StockOutInventorySerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    def show
      if @car.stock_out_inventory
        render json: @car.stock_out_inventory,
               serializer: StockOutInventorySerializer::Common,
               root: "data"
      else
        render json: { data: {} }, scope: nil
      end
    end

    private

    def find_car
      @car = Car.find(params[:car_id])
    end

    def alliance_stock_out
      service = Car::AllianceStockOutService.new(user: current_user,
                                                 car: @car,
                                                 params: @output_params
                                                 .except(:stock_out_inventory_type)
                                                 .merge(from_company_id: @car.company_id))
                                            .create

      if service.valid?
        render json: { data: service.alliance_stock_out_inventory }, scope: nil
      else
        validation_error(service.errors)
      end
    end

    def alliance_refund
      service = Car::AllianceStockOutService.new(user: current_user,
                                                 new_car: @car,
                                                 params: @output_params
                                                  .except(:stock_out_inventory_type))
                                            .update

      if service.valid?
        render json: { data: service.alliance_stock_out_inventory }, scope: nil
      else
        validation_error(service.errors)
      end
    end

    def stock_out
      begin
        service = Car::StockOutService.new(current_user, @car, @output_params).create
      rescue Intention::CheckService::InvalidError => e
        return forbidden_error(e.message)
      rescue Car::StockOutService::ProcessingError
        return already_accepted
      end

      if service.valid?
        render json: service.stock_out_inventory,
               serializer: StockOutInventorySerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    def validate_param!
      param! :stock_out_inventory, Hash, required: true do |a|
        a.param!(
          :stock_out_inventory_type,
          String,
          in: StockOutInventory.stock_out_inventory_type.values + %w(alliance alliance_refunded),
          transform: :downcase,
          default: "sold"
        )
        a.param!(
          :payment_type,
          String,
          in: StockOutInventory.payment_type.values,
          transform: :downcase,
          default: "cash"
        ) unless a.params[:stock_out_inventory_type].include? "alliance"
        if a.params[:stock_out_inventory_type] == "alliance"
          a.param! :alliance_id, Integer, required: true
          a.param! :company_id, Integer, required: true
          a.param! :seller_id, Integer, required: true
          a.param! :closing_cost_wan, Float, required: true
          a.param! :deposit_wan, Float, required: true
          a.param! :remaining_money_wan, Float, required: true
          a.param! :completed_at, Date, required: true
          a.param! :to_shop_id, Integer, required: true
        end
        if a.params[:stock_out_inventory_type] == "alliance_refunded"
          a.param! :refunded_price_wan, Float, required: true
          a.param! :refunded_at, Date, required: true
        end
      end
    end
  end
end
