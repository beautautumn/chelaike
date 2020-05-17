class Company < ActiveRecord::Base
  class CarStatisticService
    # 相关算法 http://git.che3bao.com/autobots/prime-mobile/issues/878#note_19904
    def initialize(user, date, shop_id = nil)
      @user = user

      @shop_id = shop_id
      @scope = if shop_id.blank?
                 @user.company
               else
                 @user.company.shops.find(shop_id)
               end

      init_times(date)
    end

    def cars_by_day
      Rails.cache.fetch(cars_cache_key) do
        {
          cars_acquired: cars_acquired.size, # 日已入库
          cars_sold: cars_sold.size,         # 日已出库
          cars_reserved: cars_reserved.size, # 日已预定
          ghost_cars: ghost_cars.size        # 遗留单
        }
      end
    end

    def cars_by_month
      Rails.cache.fetch(cars_cache_key(:month)) do
        averge_stock_age_days = count_averge_stock_age_days
        stock_turnover = count_stock_turnover(averge_stock_age_days)

        {
          cars_acquired: cars_acquired_by_month.size,                         # 月已入库
          cars_sold: cars_sold_by_month.size,                                 # 月已出库
          stock_by_month: stock_by_month.size,                                # 月库存
          averge_stock_age_days: averge_stock_age_days,                       # 平均库存周期
          stock_turnover: stock_turnover,                                     # 库存周转
          current_in_stock: current_in_stock.size                             # 当前在库车辆数
        }.merge!(cash_analysis)
      end
    end

    def cash_analysis
      car_analysis = Dw::Analysis::Car.new(@user.company_id, shop_id: @shop_id)
      acquisition_amount = car_analysis.acquisition_amount(
        car_analysis.acquired_at_conditions(@date, "month")
      )

      out_stock_info = car_analysis.out_stock_info(
        car_analysis.stock_out_at_conditions(@date, "month")
      )
      out_stock_amount = out_stock_info.fetch(:out_stock_amount)
      cash_turnover = count_cash_turnover(car_analysis, out_stock_amount)

      {
        acquisition_amount: acquisition_amount,                                    # 月收购金额
        out_stock_amount: out_stock_amount.round(2),                               # 月出库金额
        cash_turnover: cash_turnover,                                              # 资金周转率
        cash_conversion_cycle: count_cash_conversion_cycle(cash_turnover),         # 资金周转周期

        gross_profit: out_stock_info.fetch(:car_gross_profit),                     # 月毛利
        gross_profit_rate: out_stock_info.fetch(:car_gross_profit_rate),           # 月毛利率

        stock_by_month_total_amount: stock_by_month_acquisition_amount,            # 当月在库收购价
        estimated_gross_profit_amount: car_analysis.estimated_gross_profit_amount( # 当前在库预计毛利总和
          car_id_in: current_in_stock.pluck(:id) + [-1]
        )
      }
    end

    # ------------------------日期函数--------------------------------
    # 日已入库
    def cars_acquired
      @scope.cars.acquired_between(@beginning_of_day, @end_of_day)
    end

    # 日已出库
    def cars_sold
      @scope.cars.state_out_of_stock_scope
            .stock_out_between(@beginning_of_day, @end_of_day)
    end

    # 日已预定
    def cars_reserved
      @scope.cars.joins(
        <<-SQL.squish!
          LEFT JOIN car_reservations ON car_reservations.car_id = cars.id
        SQL
      ).where(
        "car_reservations.reserved_at >= ? AND car_reservations.reserved_at <= ?",
        @beginning_of_day, @end_of_day
      ).uniq
    end

    # 遗留单
    def ghost_cars
      @scope.cars.where(reserved: true)
            .where("reserved_at <= ?", @beginning_of_day)
            .where.not(state: %w(driven_back acquisition_refunded))
    end
    # --------------------------------------------------------------

    # -------------------------月函数--------------------------------
    # 月入库累计
    def cars_acquired_by_month
      @scope.cars.acquired_between(@beginning_of_month, @end_of_month)
    end

    # 月出库累计
    def cars_sold_by_month
      @scope.cars.state_out_of_stock_scope
            .stock_out_between(@beginning_of_month, @end_of_month)
    end

    # 月库存
    def stock_by_month
      @scope.cars.stock_by_month(@beginning_of_month, @end_of_month)
    end

    # 当前在库
    def current_in_stock
      @scope.cars.state_in_stock_scope
    end

    # 平均库零
    def count_averge_stock_age_days
      averge_stock_age_days_sql = <<-SQL.squish!
        ROUND(
          AVG(cars.stock_age_days * 1.0), 2
        ) AS averge_stock_age_days
      SQL

      stock_by_month.select(averge_stock_age_days_sql)
                    .as_json
                    .last
                    .fetch("averge_stock_age_days")
                    .to_f
    end

    # 月在库总收购价
    def stock_by_month_acquisition_amount
      stock_by_month.select(acquisition_amount_field)
                    .as_json
                    .last
                    .fetch("acquisition_amount")
                    .to_f
    end

    # 库存周转率
    def count_stock_turnover(averge_stock_age_days)
      return 0 if averge_stock_age_days == 0

      (turnover_range.to_f / averge_stock_age_days).round(2)
    end

    # 资金周转率
    def count_cash_turnover(car_analysis, out_stock_amount)
      initial_total_assets = car_analysis.acquisition_amount(
        car_id_in: car_analysis.in_stock_by_time_car_ids(@beginning_of_month) + [-1]
      )
      car_ids = if current_month?
                  car_analysis.in_stock_by_time_car_ids(@end_of_day)
                else
                  car_analysis.in_stock_by_time_car_ids(@end_of_month)
                end

      final_total_assets = car_analysis.acquisition_amount(car_id_in: car_ids + [-1])

      average_balance_of_total_assets = (initial_total_assets + final_total_assets) / 2

      (out_stock_amount.to_f / average_balance_of_total_assets).round(2)
    end

    # 资金周转周期
    def count_cash_conversion_cycle(cash_turnover)
      return 0 if cash_turnover == 0

      (turnover_range.to_f / cash_turnover).round(2)
    end

    def turnover_range
      30
    end

    # --------------------------------------------------------------

    private

    def cars_cache_key(prefix = :day)
      return "#{prefix}:#{scope_uuid}" if latest_car.blank?

      "#{prefix}:#{scope_uuid}:#{latest_car.updated_at}"
    end

    def latest_car
      @_latest_car ||= @scope.cars.order(:updated_at).last
    end

    def scope_uuid
      "#{@scope.id}:#{@scope.class.name}:#{@date}"
    end

    def init_times(date)
      @date = date.in_time_zone

      @beginning_of_day = @date.beginning_of_day
      @end_of_day = @beginning_of_day.end_of_day
      @beginning_of_month = @date.beginning_of_month
      @end_of_month = @date.end_of_month
    end

    def current_month?
      now = Time.zone.now

      @date.year == now.year && @date.month == now.month
    end

    def acquisition_amount_field
      <<-SQL.squish!
        ROUND(
          (
            SUM(cars.acquisition_price_cents)
               * 1.0 / #{Util::ExchangeRate.cents_by_unit}
          ), 2
        ) AS acquisition_amount
      SQL
    end
  end
end
