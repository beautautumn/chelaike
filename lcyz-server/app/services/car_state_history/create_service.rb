class CarStateHistory < ActiveRecord::Base
  class CreateService
    include ErrorCollector

    attr_accessor :car_state_history

    def initialize(user, car, params)
      @user = user
      @car = car
      @params = params
    end

    def execute
      @car_state_history = @car.car_state_histories.new(
        @params.merge!(previous_state: @car.state)
      )

      fallible @car, @car_state_history

      begin
        CarStateHistory.transaction do
          @car_state_history.save!
          @car.update!(
            sellable: @car_state_history.sellable,
            state: @car_state_history.state,
            state_note: @car_state_history.note,
            state_changed_at: @car_state_history.state_changed_at,
            predicted_restocked_at: @car_state_history.predicted_restocked_at
          )
          create_operation_records
        end
      rescue ActiveRecord::RecordInvalid
        @car
      end

      self
    end

    def create_operation_records
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :state_changed,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: "状态更新",
          stock_number: @car.stock_number,
          user_name: @user.name,
          name: @car.name,
          previous_state: @car_state_history.previous_state,
          current_state: @car_state_history.state
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
