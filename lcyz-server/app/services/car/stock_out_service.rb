# 车辆出库
class Car < ActiveRecord::Base
  class StockOutService
    include ErrorCollector
    class ProcessingError < StandardError; end

    attr_reader :stock_out_inventory

    def initialize(user, car, params)
      @user = user
      @car = car
      @params = params

      set_operator
    end

    def update
      @stock_out_inventory = @car.find_or_create_stock_out_inventory
      fallible @car, @stock_out_inventory

      assign_attributes_to_stock_out_inventory(@params)
      within_valid_stock_out_inventory_type! { |type| send(type) }

      self
    end

    def create
      # check!
      raise ProcessingError if RedisClient.current.get(mutex_key).present?
      processing do
        @stock_out_inventory = @car.find_or_init_stock_out_inventory
        fallible @car, @stock_out_inventory

        assign_attributes_to_stock_out_inventory(@params)
        within_valid_stock_out_inventory_type! { |type| send(type) }
      end

      execute_publish if @stock_out_inventory.persisted?

      self
    end

    def assign_attributes_to_stock_out_inventory(params)
      @stock_out_inventory.assign_attributes(params)
      @stock_out_inventory.shop_id = @car.shop_id
    end

    def within_valid_stock_out_inventory_type!
      type = @stock_out_inventory.stock_out_inventory_type

      if StockOutInventory.stock_out_inventory_type.values.include?(type)
        yield(type)
      else
        raise RailsParam::Param::InvalidParameterError
      end
    end

    {
      sell: :sold,
      acquisition_refund: :acquisition_refunded,
      drive_back: :driven_back
    }.each do |action, type|
      define_method type do
        unless @car.public_send("may_#{action}?")
          return @stock_out_inventory.errors.add(:state, "当前车辆状态无法出库")
        end

        begin
          ActiveRecord::Base.connection.transaction do
            @stock_out_inventory.set_as_current! if @stock_out_inventory.new_record?

            @car.public_send("#{action}!")
            @stock_out_inventory.save!

            associate_intention if action == :sell && @params[:customer_phone].present?

            update_finance_car_income(type)
            create_operation_record(type)
          end
        rescue ActiveRecord::RecordInvalid
          @stock_out_inventory
        end
      end
    end

    private

    def processing
      ex_time = 1 * 60
      RedisClient.current.setex(mutex_key, ex_time, "1")
      yield
    end

    def mutex_key
      @_mutex_key ||= "Car::StockOutService:#{@car.id}"
    end

    def check!
      Intention::CheckService.new(@user, agency: true).check!(
        customer_phones: [@params[:customer_phone]],
        intention_type: "seek"
      )
    end

    def execute_publish
      params = @car.che168_publish_record.try(:attributes).try(:with_indifferent_access)
      Publisher::Che168Service.new(@user, @car, params).execute(:sold)
    end

    def associate_intention
      service = Intention::AssociateService.new(
        customer_id: @stock_out_inventory.customer_id,
        customer_params: @params,
        user: @user,
        car: @car,
        intention_state: "completed"
      )
      service.execute

      if service.customer
        @stock_out_inventory.update!(customer_id: service.customer.id)

        customer_errors = service.customer.errors
        if customer_errors.include?(:phone)
          @stock_out_inventory.errors.add(:customer_phone, customer_errors.get(:phone))

          raise(ActiveRecord::RecordInvalid, @stock_out_inventory)
        end
      end

      hand_over(service)
    end

    def update_finance_car_income(type)
      closing_cost_wan = case type
                         when :sold
                           @params[:closing_cost_wan]
                         when :acquisition_refunded
                           @params[:refund_price_wan]
                         when :driven_back
                           @params[:acquisition_price_wan]
                         end
      @finance_car_income = @car.find_or_create_finance_car_income
      @finance_car_income.update!(closing_cost_wan: closing_cost_wan)
    end

    def create_operation_record(stock_out_type)
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :stock_out,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: @stock_out_inventory.stock_out_inventory_type_text,
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name,

          stock_out_type: stock_out_type,
          seller_id: @stock_out_inventory.seller_id,
          seller_name: @stock_out_inventory.seller.try(:name)
        },
        user_passport: @user.passport.to_h
      )
    end

    def set_operator
      @params[:operator_id] = @user.id
    end
  end
end
