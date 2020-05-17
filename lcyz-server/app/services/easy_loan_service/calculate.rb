module EasyLoanService
  class Calculate
    attr_accessor :company, :weight, :debit, :debts_setting_rating, :element, :region

    CalculateError = Class.new(StandardError)

    def initialize(company_id, date)
      @company = Company.find(company_id)
      @weight = EasyLoan::Setting.first
      init_times(date)
      init_debit
      @debts_setting_rating = industry_assets_debts_rating
      @element = cuculate_element
      @region = region_score
    end

    # 资金周转率得分映射
    CASH_TURNOVER_RANGE = {
      "1" => (0..0.3),
      "2" => (0.31..0.5),
      "3" => (0.51..0.8),
      "4" => (0.81..1.2),
      "5" => (1.21..1000)
    }

    # 毛利润得分映射
    GROSS_PROFIR_RANGE = {
      "1" => (-1000..0.03),
      "2" => (0.031..0.04),
      "3" => (0.041..0.06),
      "4" => (0.061..0.08),
      "5" => (0.081..1)
    }

    # 资产负债率得分映射
    ASSETS_DEBTS_RANGE = {
      "5" => (0...0.4),
      "4" => (0.4...0.5),
      "3" => (0.5...0.6),
      "2" => (0.6...0.8),
      "1" => (0.8..1)
    }

    # 经营健康评级
    def operating_health
      # 资产负债率大于等于0.75
      if @debts_setting_rating.fetch(:assets_debts_rating).to_f >= 0.75
        if stock_turnover.to_f < 0.8
          # 库存周转小于 0.8
          1
        elsif stock_turnover >= 0.8
          # 库存周转大于等于 0.8
          2
        end
      elsif @debts_setting_rating.fetch(:assets_debts_rating).to_f < 0.75
        operator_helth = BigDecimal.new(@element.fetch(:cash_turnover_score).to_s) * (
          (
            BigDecimal.new(@element.fetch(:gross_profit_score).to_s) * @weight.try(:gross_rake) +
            BigDecimal.new(@element.fetch(:assets_debts_score).to_s) * @weight.try(:assets_debts_rate)
          ) / BigDecimal.new("5")
        ).to_f.round(0)

        operating_health = operator_helth == 0 ? 1 : operator_helth
      end
    end

    # 综合评级
    def comprehensive_rating
      # 计算公式:
      # 库存资金量评级 * weight + 经营健康评级 * weight + 行业风评 * weight
      BigDecimal.new(inventory_amount_rating.to_s) * @weight.try(:inventory_amount) +
      BigDecimal.new(operating_health.to_s) * @weight.try(:operating_health) +
      @debts_setting_rating.fetch(:industry_rating) * @weight.try(:industry_rating)
    end

    # 库存资金量评级
    def inventory_amount_rating
      inventory_amount_rating = (BigDecimal.new(inventory_amount) / BigDecimal.new(1000.to_s)).round(0)
      inventory_amount_rating = 5 if inventory_amount_rating > 5

      return inventory_amount_rating
    end

    def beat
      # 根据三角行分布公式算
      @region.inject({}) do |result, (k, v)|
        rate = comprehensive_rating
        if v.present? && (v.fetch(:min).to_f..v.fetch(:utmost).to_f).include?(rate.to_f)
          result.merge(k.to_sym => (
                          (BigDecimal.new(rate.to_s) - BigDecimal.new(v.fetch(:min).to_s))**2 /
                          (
                            (BigDecimal.new(v.fetch(:max).to_s) - BigDecimal.new(v.fetch(:min).to_s)) *
                            (BigDecimal.new(v.fetch(:utmost).to_s) - BigDecimal.new(v.fetch(:min).to_s))
                          )
          ))
        elsif v.present? && (v.fetch(:utmost).to_f..v.fetch(:max).to_f).include?(rate.to_f)
          result.merge(k.to_sym => (BigDecimal.new("1") - (
            (BigDecimal.new(v.fetch(:max).to_s) - BigDecimal.new(rate.to_s)) ** 2 /
            (
              (BigDecimal.new(v.fetch(:max).to_s) - BigDecimal.new(v.fetch(:min).to_s)) *
              (BigDecimal.new(v.fetch(:max).to_s) - BigDecimal.new(v.fetch(:utmost).to_s))
            )
          )))
        end
      end
    end

    # 月在库总收购价(库存资金量)
    def inventory_amount
      real_inventory_amount = stock_by_month.select(acquisition_amount_field)
                    .as_json
                    .last
                    .fetch("acquisition_amount")
                    .to_f.round(0).to_i

      if real_inventory_amount < 500
        return 500
      elsif real_inventory_amount > 500 && real_inventory_amount <= 1000
        return 1000
      end

      real_inventory_amount_str = real_inventory_amount.to_s
      length = real_inventory_amount_str.length
      hundred_num = real_inventory_amount_str[length - 3, 1]

      if 0 <= hundred_num.to_i && hundred_num.to_i <= 4
        return "#{real_inventory_amount_str[0, length - 3]}500".to_i
      elsif hundred_num.to_i > 4
        return "#{real_inventory_amount_str[0, length - 4]}#{real_inventory_amount_str[length - 4, 1].to_i + 1}000".to_i
      end

    end

    # 真实库存资金量
    def real_inventory_amount
      stock_by_month.select(acquisition_amount_field)
                    .as_json
                    .last
                    .fetch("acquisition_amount")
                    .to_f
    end

    def update_debit
      @debit.update_attributes(
              real_inventory_amount: real_inventory_amount, inventory_amount: inventory_amount,
              operating_health: operating_health.to_s, comprehensive_rating: comprehensive_rating.to_s,
              beat_global: beat.try(:fetch, :global), beat_local: beat.try(:fetch, :local),
              cash_turnover_rate: @element.fetch(:cash_turnover_rate).to_s,
              car_gross_profit_rate: @element.fetch(:gross_profit_rate).to_s
      )
    end

    # 库存周转
    def stock_turnover
      averge_stock_age_days = count_averge_stock_age_days
      stock_turnover = count_stock_turnover(averge_stock_age_days)
      return stock_turnover
    end

    private

    # 计算要素：资金周转率评级，月毛利率评级，资产负债率评级
    def cuculate_element
      car_analysis = Dw::Analysis::Car.new(@company.id)

      out_stock_info = car_analysis.out_stock_info(
        car_analysis.stock_out_at_conditions(@date, "month")
      )
      out_stock_amount = out_stock_info.fetch(:out_stock_amount)

      gross_profit_rate = out_stock_info.fetch(:car_gross_profit_rate)
      cash_turnover = count_cash_turnover(car_analysis, out_stock_amount)

      cash_turnover = 0 if cash_turnover.infinite? == 1
      gross_profit_rate = 0 if gross_profit_rate.to_f.nan?

      @element = {
        cash_turnover_score: get_score("cash_turnover", cash_turnover.to_f),                               # 资金周转率评级
        cash_turnover_rate: cash_turnover,                                                                 # 资金周转率
        gross_profit_rate: gross_profit_rate,                                                              # 月利润率
        gross_profit_score: get_score("gross_profit", (gross_profit_rate.to_f/100)),                       # 月利润率评级
        assets_debts_score: get_score("assets_debts", @debts_setting_rating[:assets_debts_rating])         # 资产负债率评级
      }.symbolize_keys
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

    # 车商每月资产负债率和行业风评数据
    def industry_assets_debts_rating
      @debts_setting_rating = {
        industry_rating: @debit.try(:industry_rating), # 行业风评
        assets_debts_rating: @debit.try(:assets_debts_rating) # 资产负债率
      }.symbolize_keys
    end

    # 库存周转率
    def count_stock_turnover(averge_stock_age_days)
      return 0 if averge_stock_age_days == 0

      (turnover_range.to_f / averge_stock_age_days).round(2)
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

    def init_times(date)
      @date = date.in_time_zone

      @beginning_of_day = @date.beginning_of_day
      @end_of_day = @beginning_of_day.end_of_day
      @beginning_of_month = @date.beginning_of_month
      @end_of_month = @date.end_of_month
    end

    def init_debit
      @debit = EasyLoan::Debit.with_date_and_company(@company, Time.now.year, @date.month).first
      unless @debit
        @debit = EasyLoan::Debit.create(
                    company: @company, industry_rating: @company.industry_rating,
                    assets_debts_rating: @company.assets_debts_rating)
      end
    end

    def region_score
      {
        global: EasyLoan::City.find_by_name("全国").try(:score).try(:symbolize_keys),
        local: EasyLoan::City.where('name LIKE ?', "%#{@company.try(:city)}%").first.try(:score).try(:symbolize_keys)
      }.symbolize_keys
    end

    def current_month?
      now = Time.zone.now

      @date.year == now.year && @date.month == now.month
    end

    def turnover_range
      30
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

    # 月在库车辆
    def stock_by_month
      @company.cars.stock_by_month(@beginning_of_month, @end_of_month)
    end

    def get_score(type, value)
      case type
      when "cash_turnover"
        CASH_TURNOVER_RANGE.inject(0){ |result, (k,v)| return result = k.to_i if v === value }
      when "gross_profit"
        GROSS_PROFIR_RANGE.inject(0){ |result, (k,v)| return result = k.to_i if v === value }
      when "assets_debts"
        ASSETS_DEBTS_RANGE.inject(0){ |result, (k,v)| return result = k.to_i if v === value }
      end
    end
  end
end
