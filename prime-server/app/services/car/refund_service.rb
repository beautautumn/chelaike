class Car < ActiveRecord::Base
  class RefundService
    include ErrorCollector

    attr_reader :refund_inventory

    def initialize(user, car, params)
      @user = user
      @car = car
      @params = params
    end

    def execute
      @refund_inventory = @car.refund_inventories.new(@params)
      @refund_inventory.refund_inventory_type = @car.state

      fallible @car, @refund_inventory

      if @car.may_return_to_hall?
        begin
          Car.transaction do
            @refund_inventory.save!
            @car.return_to_hall!

            if @refund_inventory.acquisition_refunded?
              @car.update!(acquisition_price_wan: @refund_inventory.acquisition_price_wan)
            end

            @car.car_reservations.update_all(current: false)

            create_operation_record
          end
        rescue ActiveRecord::RecordInvalid
          @refund_inventory
        end
      else
        @refund_inventory.errors.add(:base, "操作失败")
      end

      self
    end

    def create_operation_record
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :stock_back,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: "车辆回库",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name,
          note: @refund_inventory.note
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
