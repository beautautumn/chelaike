class Car < ActiveRecord::Base
  class DeleteService
    attr_reader :car

    def initialize(user, car)
      @user = user
      @car = car
    end

    def execute
      begin
        Car.transaction do
          @car.destroy!
          create_operation_record
        end
      rescue ActiveRecord::RecordInvalid
        @car
      end

      self
    end

    private

    def create_operation_record
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :car_deleted,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: "车辆删除",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name,

          imported: @car.imported.present?,
          acquirer_name: @car.acquirer.try(:name)
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
