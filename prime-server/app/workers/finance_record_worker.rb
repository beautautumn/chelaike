class FinanceRecordWorker
  include Sidekiq::Worker

  def perform(company_id)
    @company = Company.find(company_id)
    generate_finance_record
  end

  def generate_finance_record
    @company.cars.find_each do |car|
      Finance::CarIncome.transaction do
        # 创建车辆财务记录
        car.find_or_create_finance_car_income
        # 创建每月资金费用
        service = FinanceService::CarFees.new(car.company.owner, car.reload)
        service.generate_monthly_fund_cost
      end
    end
  end
end
