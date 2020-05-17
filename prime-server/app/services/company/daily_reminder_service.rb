class Company < ActiveRecord::Base
  class DailyReminderService
    include ErrorCollector

    class NoAssigneeError < StandardError; end
    class AssigneeNoShopError < StandardError; end

    def initialize(company, params: nil)
      @company = company
      @params = params
      @beginning_of_day = Time.zone.now.beginning_of_day
      @end_of_day = Time.zone.now.end_of_day
    end

    def execute
      create_due_today_messages
      create_prepare_finish_messages
      create_stock_warning_messages
      create_restock_today_messages
    end

    def create_due_today_messages
      return if intentions_due_today.blank?
      intentions_due_today.each do |intention|
        intention.operation_records.create!(
          user: intention.assignee,
          company_id: @company.id,
          operation_record_type: :remind_intention_due,
          shop_id: intention.shop_id,
          messages: {
            intention_id: intention.id,
            intention_type: intention.intention_type,
            title: "跟进到期",
            user_name: intention.assignee.try(:name),
            car_name: intention.intention_cars_text,
            customer_name: intention.customer_name
          },
          user_passport: @company.owner.passport.to_h
        )
      end
    end

    def create_prepare_finish_messages
      return if prepare_finish.blank?
      Car.where(id: prepare_finish).each do |car|
        car.operation_records.create!(
          user: @company.owner,
          company_id: @company.id,
          operation_record_type: :prepare_finish,
          shop_id: car.shop_id,
          messages: {
            title: "整备提醒",
            car_id: car.id,
            user_name: @company.owner.try(:name),
            car_name: car.name
          }
        )
      end
    end

    def create_stock_warning_messages
      yellow_stock_warnging_cars.each do |car|
        car.operation_records.create!(
          user: @company.owner,
          company_id: @company.id,
          operation_record_type: :stock_warning,
          shop_id: car.shop_id,
          messages: {
            title: "库存预警",
            user_name: @company.owner.try(:name),
            car_name: car.name,
            car_id: car.id,
            stock_status: "黄色预警"
          }
        )
      end

      red_stock_warnging_cars.each do |car|
        car.operation_records.create!(
          user: @company.owner,
          company_id: @company.id,
          operation_record_type: :stock_warning,
          shop_id: car.shop_id,
          messages: {
            title: "库存预警",
            user_name: @company.owner.try(:name),
            car_name: car.name,
            car_id: car.id,
            stock_status: "红色预警"
          }
        )
      end
    end

    def create_restock_today_messages
      restock_today_cars.each do |car|
        car.operation_records.create!(
          user: @company.owner,
          company_id: @company.id,
          operation_record_type: :remind_restock,
          shop_id: car.shop_id,
          messages: {
            title: "车辆今日到店",
            user_name: @company.owner.try(:name),
            car_name: car.name,
            car_id: car.id,
            color: car.exterior_color,
            stock_number: car.stock_number,
            state: car.state_text
          }
        )
      end
    end

    def yellow_stock_warnging_cars
      Car.where(company_id: @company.id).state_in_stock_scope
         .where("stock_age_days = yellow_stock_warning_days")
    end

    def red_stock_warnging_cars
      Car.where(company_id: @company.id).state_in_stock_scope
         .where("stock_age_days = red_stock_warning_days")
    end

    def intentions_due_today
      scope = @company.intentions.with_customer
      # 今日待跟进, 今日待接待
      (scope.where(processing_time: Time.zone.now.beginning_of_day...Time.zone.now.end_of_day) +
        scope.where(interviewed_time: Time.zone.now.beginning_of_day...Time.zone.now.end_of_day))
        .uniq
    end

    # 客户生日, 年审, 保险, 按揭到期等 demands#132
    def remind_service
      # TBD
    end

    # 整备完成提醒 demands#224
    def prepare_finish
      PrepareRecord.joins(:car).where("cars.company_id = #{@company.id}")
                   .where(estimated_completed_at: Time.zone.tomorrow)
                   .pluck(:car_id)
    end

    # 车辆回厅提醒 autobots/demands#307
    def restock_today_cars
      Car.where(company_id: @company.id)
         .state_in_stock_scope
         .where(predicted_restocked_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    end
  end
end
