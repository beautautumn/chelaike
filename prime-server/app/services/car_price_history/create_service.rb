class CarPriceHistory < ActiveRecord::Base
  class CreateService
    include ErrorCollector

    attr_reader :car_price_history

    def initialize(user, car, params)
      @user = user
      @car = car
      @params = params.merge!(user: user)
    end

    def execute
      begin
        new_car_price_attributes = @params.extract!(
          :new_car_guide_price_wan,
          :new_car_additional_price_wan,
          :new_car_discount,
          :new_car_final_price_wan
        )
        @car_price_history = @car.car_price_histories.new(@params)

        fallible @car, @car_price_history

        CarPriceHistory.transaction do
          save_car_price_history!

          update_car!(new_car_price_attributes)

          create_operation_record
        end
      rescue ActiveRecord::RecordInvalid
        @car_price_history
      end

      self
    end

    def create_operation_record
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :car_priced,
        shop_id: @car.shop_id,
        messages: @car_price_history.slice(
          :user_name, :previous_show_price_wan,
          :show_price_wan, :previous_online_price_wan, :online_price_wan,
          :previous_sales_minimun_price_wan, :sales_minimun_price_wan,
          :previous_manager_price_wan, :manager_price_wan,
          :previous_alliance_minimun_price_wan, :red_stock_warning_days,
          :alliance_minimun_price_wan, :yellow_stock_warning_days, :note
        ).merge(
          title: "车辆定价", name: @car.name,
          stock_number: @car.stock_number, car_id: @car.id
        ),
        user_passport: @user.passport.to_h
      )
    end

    private

    def save_car_price_history!
      @car_price_history.assign_attributes(
        user_name: @car_price_history.user.name,
        previous_show_price_wan: @car.show_price_wan,
        previous_online_price_wan: @car.online_price_wan,
        previous_sales_minimun_price_wan: @car.sales_minimun_price_wan,
        previous_manager_price_wan: @car.manager_price_wan,
        previous_alliance_minimun_price_wan: @car.alliance_minimun_price_wan
      )
      @car_price_history.save!
    end

    def update_car!(new_car_price_attributes)
      car_base_params = {
        show_price_wan: @car_price_history.show_price_wan,
        online_price_wan: @car_price_history.online_price_wan,
        sales_minimun_price_wan: @car_price_history.sales_minimun_price_wan,
        manager_price_wan: @car_price_history.manager_price_wan,
        alliance_minimun_price_wan: @car_price_history.alliance_minimun_price_wan,
        yellow_stock_warning_days: @car_price_history.yellow_stock_warning_days,
        red_stock_warning_days: @car_price_history.red_stock_warning_days
      }.merge!(@params[:car_attributes] || {})

      car_params = car_base_params.merge!(new_car_price_attributes)
      @car.update!(car_params)
    end
  end
end
