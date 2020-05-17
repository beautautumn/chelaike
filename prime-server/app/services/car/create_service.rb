class Car < ActiveRecord::Base
  class CreateService
    class InvalidVinError < StandardError; end
    attr_reader :car

    def initialize(user, car, acquisition_transfer_params,
                   publisher_params = {}, alliance_stock_in: false)
      @user = user
      @car = car
      @acquisition_transfer_params = acquisition_transfer_params
      @publisher_params = publisher_params
      @alliance_stock_in = alliance_stock_in
    end

    def execute
      authority_checkout!

      check_vin!
      begin
        Car.transaction do
          execute_acquisition_transfer
          execute_sale_transfer
          execute_prepare_record
          execute_finance_income

          @car.save!
          create_operation_record
        end
      rescue ActiveRecord::RecordInvalid
        @car
      end

      self
    end

    # 根据收车信息创建入库车辆
    def acquisition_create(self_acquisition = false)
      begin
        Car.transaction do
          execute_acquisition_transfer
          execute_sale_transfer
          execute_prepare_record

          handle_car_acquisition_type(self_acquisition)

          @car.save!
          acquisition_operation_record(self_acquisition)
        end

      rescue ActiveRecord::RecordInvalid
        @car
      end

      self
    end

    private

    def check_vin!
      return if @car.vin.blank?
      same_vin_car = @user.company.cars.state_in_stock_scope.where(vin: @car.vin).first
      return unless same_vin_car
      brand_name = same_vin_car.brand_name
      series_name = same_vin_car.series_name
      stock_num = same_vin_car.stock_number
      error_message = "该车与在库车辆\“#{brand_name}#{series_name}【库存号：#{stock_num}】”车架号重复，请排查！"
      @car.errors.add(:vin, error_message)
      raise InvalidVinError, error_message
    end

    def handle_car_acquisition_type(self_acquisition)
      @car.acquisition_type = "cooperation" unless self_acquisition
    end

    def execute_sale_transfer
      @car.build_sale_transfer(@car.acquisition_transfer.shared_attributes)
    end

    def execute_acquisition_transfer
      @acquisition_transfer_params[:items] = []
      if @acquisition_transfer_params[:compulsory_insurance]
        @acquisition_transfer_params[:items] << "compulsory_insurance"
      end
      if @acquisition_transfer_params[:commercial_insurance]
        @acquisition_transfer_params[:items] << "commercial_insurance"
      end

      @acquisition_transfer_params.delete(:commercial_insurance)
      @acquisition_transfer_params.delete(:compulsory_insurance)

      @car.build_acquisition_transfer(
        @acquisition_transfer_params.merge(
          user_id: @car.acquirer_id,
          shop_id: @car.shop_id,
          vin: @car.vin
        )
      )
    end

    def execute_prepare_record
      @car.build_prepare_record
    end

    def execute_finance_income
      @car.build_finance_car_income(
        company_id: @user.company_id,
        acquisition_price_cents: @car.acquisition_price_cents.to_i
      )
    end

    def authority_checkout!
      @acquisition_transfer_params = {} unless @user.can?("牌证信息录入")
    end

    def acquisition_operation_record(self_acquisition)
      if self_acquisition
        create_operation_record
      else
        boss = @car.company.owner
        create_operation_record(boss)
      end
    end

    def create_operation_record(user = nil)
      user ||= @user
      matched_intentions = Car::RelativeStatisticService.new(user, @car).intentions.pluck(:id)

      @car.operation_records.create!(
        user: user,
        company_id: user.company_id,
        operation_record_type: @alliance_stock_in ? :alliance_stock_in : :car_created,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: @alliance_stock_in ? "联盟入库" : "新车入库",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: user.name,
          match_intention: matched_intentions.present?,
          matched_intentions: matched_intentions,
          matched_intentions_count: matched_intentions.size,
          imported: @car.imported.present?,
          acquirer_name: @car.acquirer.name
        },
        user_passport: user.passport.to_h
      )
    end
  end
end
