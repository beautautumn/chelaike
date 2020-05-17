module FinanceService
  class CarFees
    include ErrorCollector
    attr_accessor :user, :car_fee

    def initialize(user, car)
      @user = user
      @car = car
    end

    def batch_update(fee_params_arr)
      return self if fee_params_arr.blank?
      fee_params_arr.each do |fee_params|
        fee_params = fee_params.deep_symbolize_keys
        id = fee_params[:id]
        if id.nil?
          create(fee_params)
        elsif fee_params[:_delete]
          delete(id)
        end
      end

      self
    end

    # rubocop:disable Metrics/AbcSize
    def generate_monthly_fund_cost
      # 如果没有填写借贷资金/资金利率就不生成记录
      income = @car.finance_car_income

      return if income.try(:fund_rate).to_f == 0.0 ||
                income.try(:loan_cents).to_i == 0

      begin_time = @car.acquired_at
      is_out_stock = @car.in_state_out_of_stock? && @car.stock_out_at.present?
      end_time = is_out_stock ? @car.stock_out_at : Time.zone.now

      total_cost_cents = 0
      # 计算每辆车在每个月的财务费用
      while begin_time < end_time
        end_of_month = begin_time.end_of_month

        day_count = ([end_of_month, end_time].min.to_date - begin_time.to_date).to_i + 1
        month_fund_cost_cents =
          income.try(:loan_cents).to_f *
          income.try(:fund_rate).to_f / 100 * day_count / 30
        fee = @car.finance_car_fees.find_or_create_by!(
          category: "fund_cost",
          fee_date: end_of_month
        )

        fee.update!(
          amount_cents: month_fund_cost_cents,
          note: "每月资金费用",
          user: @car.company.owner,
          creator: @car.company.owner
        )

        total_cost_cents += month_fund_cost_cents
        begin_time = end_of_month.tomorrow
      end
      income.update!(fund_cost_cents: total_cost_cents)
    end
    # rubocop:enable Metrics/AbcSize

    private

    def delete(id)
      car_fee = Finance::CarFee.find(id)
      car_income = @car.finance_car_income

      fallible car_fee

      begin
        car_fee.transaction do
          car_income.decrease_amount!(
            car_fee.category,
            car_fee.amount_cents
          )

          car_fee.destroy!
        end
      rescue Finance::CarIncome::AmountNegativeError => e
        raise e
      end
    end

    def create(car_fee_params)
      category = car_fee_params.fetch(:category)
      amount = car_fee_params.fetch(:amount)
      car_fee_params.delete(:amount)

      if category.in?(%w(payment receipt))
        car_fee_params[:amount_wan] = amount
      else
        car_fee_params[:amount_yuan] = amount
      end

      # 如果没带 user_id, 默认当前用户
      car_fee_params[:user_id] ||= @user.id

      @car_fee = @car.finance_car_fees.build(
        car_fee_params.merge(creator_id: @user.id)
      )

      fallible @car_fee

      begin
        @car_fee.transaction do
          @car_fee.save!
          car_income.increase_amount!(category, amount)
        end
      rescue ActiveRecord::RecordInvalid
        @car_fee
      end
    end

    def car_income
      Finance::CarIncome.find_or_create_by(car_id: @car.id) do |income|
        income.company_id = @user.company_id
      end
    end
  end
end
