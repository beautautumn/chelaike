require "rails_helper"

RSpec.describe FinanceService::CarFees do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:aodi_sold) { cars(:aodi_sold) }
  let(:aodi_sold_income) { finance_car_incomes(:aodi_sold_income) }

  def prepare_params(options = {})
    {
      category: "prepare_cost",
      item_name: "repair",
      fee_date: Date.new(2016, 9, 1),
      amount: 20,
      note: "随便写点备注呗"
    }.merge(options)
  end

  describe "#batch_update" do
    before do
      @aodi_wash_item = aodi.finance_car_fees.create(
        category: "prepare_cost",
        item_name: "wash",
        fee_date: Date.new(2016, 9, 1),
        amount: 23,
        note: "随便写点备注呗"
      )

      aodi_sold_income.update(
        car: aodi,
        prepare_cost_yuan: 23
      )
    end

    it "如果提交空列表, 直接返回" do
      service = FinanceService::CarFees.new(zhangsan, aodi)
      expect { service.batch_update([]) }
        .to change { aodi.finance_car_fees.count }.by(0)
    end

    it "可以添加某条费用项目记录" do
      req_params = [
        prepare_params(amount: 47)
      ]

      service = FinanceService::CarFees.new(zhangsan, aodi)
      service.batch_update(req_params)

      expect(aodi.finance_car_fees.count).to eq 2
      expect(aodi.finance_car_income.prepare_cost_yuan).to eq 70
    end

    it "可以删除某条记录" do
      req_params = [
        prepare_params(amount: 47),
        @aodi_wash_item.attributes.merge("_delete" => true)
      ]

      wash_item_id = @aodi_wash_item.id

      service = FinanceService::CarFees.new(zhangsan, aodi)
      service.batch_update(req_params)

      expect(aodi.finance_car_income.prepare_cost_yuan).to eq 47
      expect(Finance::CarFee.where(id: wash_item_id).first).to be_nil
    end

    it "添加付款时, 修改 car_incomes 中付款金额" do
      req_params = [
        prepare_params(amount: 1, category: "payment", item_name: nil)
      ]

      expect(aodi.finance_car_income.payment_wan).to eq 10
      service = FinanceService::CarFees.new(zhangsan, aodi)
      service.batch_update(req_params)

      expect(aodi.finance_car_income.reload.payment_wan).to eq 11
    end

    it "添加收款时, 修改 car_incomes 中收款金额" do
      req_params = [
        prepare_params(amount: 1, category: "receipt", item_name: nil)
      ]

      expect(aodi.finance_car_income.receipt_wan).to eq 30
      service = FinanceService::CarFees.new(zhangsan, aodi)
      service.batch_update(req_params)

      expect(aodi.finance_car_income.reload.receipt_wan).to eq 31
    end
  end

  describe "#generate_monthly_fund_cost" do
    it "创建财务费用记录" do
      service = FinanceService::CarFees.new(zhangsan, aodi_sold)
      expect { service.generate_monthly_fund_cost }
        .to change { aodi_sold.finance_car_fees.count }.by 1
    end
  end
end
