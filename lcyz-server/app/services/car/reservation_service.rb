class Car < ActiveRecord::Base
  class ReservationService
    include ErrorCollector

    attr_reader :car_reservation
    attr_reader :car_cancel_reservation

    NoReservationError = Class.new(StandardError)

    def initialize(user, car, reservation_params)
      @user = user
      @car = car
      @params = reservation_params
    end

    def create(operator)
      check!(operator)

      begin
        @car_reservation = @car.car_reservations.new(@params)
        @sale_transfer = @car.sale_transfer

        fallible @car, @car_reservation, @sale_transfer

        if @car.reserved?
          @car_reservation.errors.add(:base, "车辆已被预定")
          return self
        end

        Car.transaction do
          @car_reservation.set_as_current!
          @car.update!(reserved_at: @car_reservation.reserved_at, reserved: true)
          update_sale_transfer

          associate_intention

          @car_reservation.save!

          create_reserved_operation_record
        end
      rescue ActiveRecord::RecordInvalid
        Rails.logger.info("[Car::ReservationService#create] can not save the car_reservation")
      end

      self
    end

    def update!(operator)
      check!(operator)

      @car_reservation = @car.car_reservation
      fallible @car, @car_reservation

      return self unless update_valid?

      CarReservation.transaction do
        @car_reservation.update!(@params)

        @car.update!(reserved_at: @car_reservation.reserved_at, reserved: true)
      end

      self
    end

    def cancel
      @car_reservation = @car.car_reservation
      raise NoReservationError, "车辆未被预定" unless @car_reservation

      begin
        @params[:car_id] = @car.id
        @car_cancel_reservation = CarCancelReservation.new(@params)

        fallible @car, @car_cancel_reservation

        Car.transaction do
          @car_cancel_reservation.set_as_current!
          @car_cancel_reservation.save!

          @car.update!(reserved_at: nil, reserved: false)
          @car.car_reservations.to_histories

          cancel_intention
          create_cancelled_operation_record
        end
      rescue ActiveRecord::RecordInvalid
        Rails.logger.info(
          "[Car::ReservationService#cancel] can not save the car_cancel_reservation"
        )
      end

      self
    end

    private

    def update_valid?
      car_reserved? && reservation_is_current?
    end

    def car_reserved?
      return true if @car.reserved?
      @car_reservation.errors.add(:base, "车辆未被预定")
      false
    end

    def reservation_is_current?
      return true if @car_reservation.current?
      @car_reservation.errors.add(:base, "不是当前预定")
      false
    end

    def check!(operator)
      Intention::CheckService.new(operator, agency: true).check!(
        customer_phones: [@params.fetch(:customer_phone, "")],
        intention_type: "seek"
      )
    end

    def create_reserved_operation_record
      create_operation_record(
        :car_reserved,
        title: "车辆预定",
        seller_id: @car_reservation.seller_id,
        seller_name: @car_reservation.seller.try(:name)
      )
    end

    def create_cancelled_operation_record
      create_operation_record(
        :car_reservation_canceled,
        title: "取消预定",
        note: @car_cancel_reservation.note,
        seller_id: @car_reservation.try(:seller_id),
        seller_name: @car_reservation.try(:seller).try(:name),
        canceled_at: @car_cancel_reservation.canceled_at
      )
    end

    def create_operation_record(type, messages)
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: type,
        shop_id: @car.shop_id,
        messages: messages.merge(
          car_id: @car.id,
          name: @car.name,
          user_name: @user.name,
          stock_number: @car.stock_number
        ),
        user_passport: @user.passport.to_h
      )
    end

    def cancel_intention
      return unless @car_reservation.customer_id

      service = Intention::ReserveAssociateService.new(
        customer_id: @car_reservation.customer_id,
        customer_params: @params,
        user: @user,
        car: @car,
        intention_state: "cancel_reserved"
      )

      service.cancel_reservation
      hand_over(service)
    end

    def associate_intention
      service = Intention::ReserveAssociateService.new(
        customer_id: @car_reservation.customer_id,
        customer_params: @params,
        user: @user,
        car: @car,
        intention_state: "reserved"
      )

      service.execute

      if service.customer
        @car_reservation.customer_id = service.customer.id

        customer_errors = service.customer.errors
        if customer_errors.include?(:phone)
          @car_reservation.errors.add(:customer_phone, customer_errors.get(:phone))

          raise(ActiveRecord::RecordInvalid, @car_reservation)
        end
      end

      hand_over(service)
    end

    def update_sale_transfer
      @sale_transfer.update!(
        sale_transfer_params(
          @car_reservation.slice(
            :customer_name, :customer_idcard, :customer_location_city,
            :customer_location_province
          )
        )
      )
    end

    def sale_transfer_params(new_owner)
      {
        new_owner: new_owner[:customer_name],
        new_owner_idcard: new_owner[:customer_idcard],
        new_owner_contact_mobile: new_owner[:customer_phone],
        current_location_province: new_owner[:customer_location_province],
        current_location_city: new_owner[:customer_location_city]
      }
    end
  end
end
