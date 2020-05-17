class Car < ActiveRecord::Base
  class UpdatePrepareRecordService
    include ErrorCollector

    attr_reader :prepare_record

    def initialize(user, car, prepare_record, params)
      @user = user
      @car = car
      @prepare_record = prepare_record

      @params = params
    end

    def execute
      fallible @prepare_record

      begin
        Car.transaction do
          @prepare_record.update!(@params)

          create_operation_record
        end

        @car.notify_market_erp
      rescue ActiveRecord::RecordInvalid
        @prepare_record
      end

      self
    end

    def create_operation_record
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :prepare_record_updated,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: "车辆整备信息编辑",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
