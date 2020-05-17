module V1
  class RefundInventoriesController < ApplicationController
    before_action do
      authorize RefundInventory
    end

    before_action :find_car

    def create
      param! :refund_inventory, Hash do |a|
        a.param!(
          :refund_inventory_type,
          String,
          in: RefundInventory.refund_inventory_type.values,
          transform: :downcase,
          default: "sold"
        )
      end

      service = Car::RefundService.new(current_user, @car, refund_inventory_params)
                                  .execute
      refund_inventory = service.refund_inventory

      if service.valid?
        render json: refund_inventory,
               serializer: RefundInventorySerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    private

    def find_car
      @car = Car.where(company_id: current_user.company_id)
                .find(params[:car_id])
    end

    def refund_inventory_params
      params.require(:refund_inventory).permit(*attributes_by_car_state)
    end

    def attributes_by_car_state
      case @car.state
      when "sold"
        %w(refunded_at refund_price_wan note)
      when "acquisition_refunded"
        %w(refunded_at acquisition_price_wan note)
      when "driven_back"
        %w(refunded_at note)
      else
        %w(note)
      end
    end
  end
end
