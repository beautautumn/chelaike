class Car < ActiveRecord::Base
  class ImagesUpdateService
    include ErrorCollector
    attr_reader :car

    def initialize(user, car, car_images, acquisition_transfer_images)
      @user = user
      @car = car
      @car_images = car_images
      @acquisition_transfer_images = acquisition_transfer_images
    end

    def execute
      acquisition_transfer = @car.acquisition_transfer

      fallible @car, acquisition_transfer

      begin
        Car.transaction do
          @car.update!(@car_images)
          acquisition_transfer.update!(@acquisition_transfer_images)
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
        operation_record_type: :car_updated,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: "车辆图片更新",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
