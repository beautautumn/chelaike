class Company < ActiveRecord::Base
  class StatisticService
    def initialize(company, user)
      @company = company
      @user = user

      @beginning_of_day = Time.zone.now.beginning_of_day
      @end_of_day = @beginning_of_day.end_of_day
      @beginning_of_month = @beginning_of_day.beginning_of_month
      @end_of_month = @beginning_of_day.end_of_month
    end

    def execute
      task_statistic = TaskStatistic::Service.new(
        User::IntentionService.related_users(@user)
      )

      {
        stocks: calculate_stocks,
        seek_intention_tasks: task_statistic.seek_task_statistic,
        sale_intention_tasks: task_statistic.sale_task_statistic
      }
    end

    # ----------------------库存------------------------------------
    # 今日已出库
    def cars_sold_today
      @company.cars.where(state: "sold")
              .stock_out_between(@beginning_of_day, @end_of_day)
    end

    # 今日已预定
    def cars_reserved_today
      @company.cars.where(reserved: true)
              .where("reserved_at >= ? AND reserved_at <= ?", @beginning_of_day, @end_of_day)
    end

    # 遗留单
    def ghost_cars
      @company.cars.where(reserved: true).where("reserved_at <= ?", @beginning_of_day)
    end

    # 今日已入库
    def cars_acquired_today
      @company.cars.acquired_between(@beginning_of_day, @end_of_day)
    end

    # 本月出库累计
    def cars_sold_current_month
      @company.cars.where(state: "sold")
              .stock_out_between(@beginning_of_month, @end_of_month)
    end

    # 本月入库累计
    def cars_acquired_current_month
      @company.cars.acquired_between(@beginning_of_month, @end_of_month)
    end

    # 当前在库
    def cars_in_stock
      @company.cars.state_in_stock_scope
    end

    private

    def intention_scope
      Intention.where(assignee_id: users.pluck(:id))
    end

    def stocks_cache_key
      return @_stocks_cache_key if defined?(@_stocks_cache_key)

      latest_car = @company.cars.order(:updated_at).last

      return "#{@company.id}:#{Time.zone.today}" if latest_car.blank?

      @_stocks_cache_key = "#{@company.id}:#{latest_car.updated_at}:#{Time.zone.today}"
    end

    def calculate_stocks
      Rails.cache.fetch(stocks_cache_key) do
        {
          cars_sold_today: cars_sold_today.size,
          cars_reserved_today: cars_reserved_today.size,

          ghost_cars: ghost_cars.size,
          cars_acquired_today: cars_acquired_today.size,

          cars_sold_current_month: cars_sold_current_month.size,
          cars_acquired_current_month: cars_acquired_current_month.size,
          cars_in_stock: cars_in_stock.size
        }
      end
    end
  end
end
