class Car < ActiveRecord::Base
  class UpdateService
    class InvalidVinError < StandardError; end
    include ErrorCollector

    attr_reader :car

    def initialize(user, car, car_params, acquisition_transfer_params, publisher_params)
      @user = user
      @car = car
      @car_params = car_params
      @acquisition_transfer_params = acquisition_transfer_params
      @publisher_params = publisher_params

      authority_checkout!
    end

    def execute
      acquisition_transfer = @car.acquisition_transfer

      check_vin!
      fallible @car, acquisition_transfer
      begin
        Car.transaction do
          @car.assign_attributes(@car_params)
          diffs = { car: ObjectDiff::Car.new(@car).execute(@car.changed_attributes) }
          @car.save!

          @acquisition_transfer_params.merge!(
            user_id: @car.acquirer_id,
            vin: @car.vin,
            shop_id: @car.shop_id
          )
          acquisition_transfer.assign_attributes(@acquisition_transfer_params)

          diffs[:acquisition_transfer] = ObjectDiff::TransferRecord
                                         .new(acquisition_transfer)
                                         .execute(acquisition_transfer.changed_attributes)
          acquisition_transfer.save!

          create_operation_record(diffs)
        end

        execute_publish if @publisher_params.present?
      rescue ActiveRecord::RecordInvalid
        @car
      end

      self
    end

    private

    def check_vin!
      vin = @car_params.fetch(:vin, "")

      return if vin.blank?
      same_vin_car = @car.company.cars
                         .state_in_stock_scope
                         .where(vin: vin)
                         .where.not(id: @car.id)
                         .first
      return unless same_vin_car
      brand_name = same_vin_car.brand_name
      series_name = same_vin_car.series_name
      stock_num = same_vin_car.stock_number
      error_message = "该车与在库车辆\“#{brand_name}#{series_name}【库存号：#{stock_num}】”车架号重复，请排查！"
      @car.errors.add(:vin, error_message)
      raise InvalidVinError, error_message
    end

    def authority_checkout!
      @acquisition_transfer_params = {} unless @user.can?("牌证信息录入")
    end

    def execute_publish
      Publisher::Che168Service.new(@user, @car, @publisher_params[:che168]).execute
    end

    def create_operation_record(detail)
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :car_updated,
        shop_id: @car.shop_id,
        detail: detail,
        messages: {
          car_id: @car.id,
          title: "车辆资料更新",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
