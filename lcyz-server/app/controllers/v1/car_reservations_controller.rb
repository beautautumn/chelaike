module V1
  class CarReservationsController < ApplicationController
    before_action do
      authorize CarReservation, :manage?
    end
    before_action :find_car

    def show
      return not_found("找不到对应的预订记录, 请重新预订") unless @car.car_reservation

      render json: @car.car_reservation,
             serializer: CarReservationSerializer::Common,
             root: "data"
    end

    def create
      begin
        service = Car::ReservationService.new(current_user, @car, car_reservation_params)
                                         .create(current_user)
      rescue Intention::CheckService::InvalidError => e
        return forbidden_error(e.message)
      end

      if service.valid?
        render json: service.car_reservation,
               serializer: CarReservationSerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    def update
      begin
        service = Car::ReservationService.new(current_user, @car, car_reservation_params)
                                         .update!(current_user)
      rescue Intention::CheckService::InvalidError => e
        return forbidden_error(e.message)
      end

      if service.valid?
        render json: service.car_reservation,
               serializer: CarReservationSerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    def cancel
      begin
        service = Car::ReservationService.new(current_user, @car, cancel_reservation_params)
                                         .cancel
      rescue Car::ReservationService::NoReservationError => e
        return forbidden_error(e.message)
      end

      if service.valid?
        render json: service.car_cancel_reservation,
               serializer: CarCancelReservationSerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    private

    def car_reservation_params
      params.require(:car_reservation).permit(
        :sales_type, :reserved_at, :customer_channel_id,
        :seller_id, :closing_cost_wan, :deposit_wan, :note,
        :customer_location_province, :customer_location_city,
        :customer_location_address, :customer_name, :customer_phone,
        :customer_idcard, :proxy_insurance, :insurance_company_id,
        :commercial_insurance_fee_yuan, :compulsory_insurance_fee_yuan
      )
    end

    def cancel_reservation_params
      params.require(:cancel_reservation).permit(
        :cancelable_price_wan, :note, :canceled_at
      ).tap do |hash|
        hash[:canceled_at] = Time.zone.now if hash[:canceled_at].blank?
        hash[:car_id]      = @car.id
      end
    end

    def find_car
      @car = Car.find(params[:car_id])
    end
  end
end
