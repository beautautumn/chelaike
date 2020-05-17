class Car < ActiveRecord::Base
  class UpdatePriceService
    include ErrorCollector

    attr_reader :car, :finance_car_income

    def initialize(user, car)
      @user = user
      @car = car
      @finance_car_income = @car.finance_car_income
    end

    def in_stock(price_params)
      fallible @car, @finance_car_income

      in_stock_operation(price_params)

      self
    end

    def out_stock(price_params, stock_out_inventory_params)
      fallible @car, @finance_car_income

      out_stock_operation(price_params, stock_out_inventory_params)

      self
    end

    private

    def in_stock_operation(price_params)
      car_params = price_params.except(:note)
      note = price_params.fetch(:note)

      ActiveRecord::Base.connection.transaction do
        @car.assign_attributes(car_params)
        diffs = { car: ObjectDiff::Car.new(@car).execute(@car.changed_attributes) }
        @car.save!

        @finance_car_income.assign_attributes(price_params.slice(:acquisition_price_wan))
        @finance_car_income.save!
        create_operation_record(diffs, note)
      end
    rescue ActiveRecord::RecordInvalid
      @car
    end

    def out_stock_operation(price_params, stock_out_inventory_params)
      car_params = price_params.except(:note)
      note = price_params.fetch(:note, "")

      ActiveRecord::Base.connection.transaction do
        @car.assign_attributes(car_params)
        diffs = { car: ObjectDiff::Car.new(@car).execute(@car.changed_attributes) }
        @car.save!

        @finance_car_income.assign_attributes(price_params.slice(:closing_cost_wan))
        @finance_car_income.save!

        Car::StockOutService.new(
          @user, @car, stock_out_inventory_params.merge(price_params.slice(:closing_cost_wan))
        ).update

        create_operation_record(diffs, note)
      end

    rescue ActiveRecord::RecordInvalid
      @car
    end

    def create_operation_record(detail, note)
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :car_price_updated,
        shop_id: @car.shop_id,
        detail: detail,
        messages: {
          car_id: @car.id,
          title: "车辆价格更新",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name,
          note: note
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
