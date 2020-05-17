require "rails_helper"

RSpec.describe V1::Finance::CarFeesController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi_sold_income) { finance_car_incomes(:aodi_sold_income) }
  let(:aodi_sold) { cars(:aodi_sold) }
  before do
    give_authority(zhangsan, "财务管理")
    login_user(zhangsan)
  end

  def prepare_params(options = {})
    {
      category: "prepare_cost",
      item_name: "repair",
      fee_date: Date.new(2016, 9, 1),
      amount: 20,
      note: "随便写点备注呗"
    }.merge(options)
  end

  describe "GET index" do
    it "根据款项类型得到子费用列表" do
      aodi_sold.finance_car_fees.create(
        prepare_params
      )

      aodi_sold.finance_car_fees.create(
        prepare_params(category: "prepare_cost", item_name: "wash")
      )

      auth_get :index, car_id: aodi_sold, category: "prepare_cost"
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET payment" do
    it "得到付款信息" do
      auth_get :payment, car_id: aodi_sold
      expect(response_json[:meta][:payable]).to eq 20
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET receipt" do
    it "得到收款信息" do
      auth_get :receipt, car_id: aodi_sold
      expect(response_json[:meta][:receivable]).to eq 30
      expect(response_json[:data]).to be_present
    end
  end

  describe "PUT batch_update" do
    before do
      @aodi_wash_item = aodi_sold.finance_car_fees.create(
        category: "prepare_cost",
        item_name: "wash",
        fee_date: Date.new(2016, 9, 1),
        amount: 23,
        note: "随便写点备注呗"
      )

      aodi_sold_income.update(
        car: aodi_sold,
        prepare_cost_yuan: 23
      )
    end

    it "可以添加某条费用项目记录" do
      req_params = [
        prepare_params(amount: 47)
      ]

      auth_put :batch_update, car_id: aodi_sold, car_fees: req_params

      expect(response_json[:data][:prepare_cost_yuan].to_i).to eq 70
    end

    it "可以删除某条记录" do
      req_params = [
        prepare_params(amount: 47),
        @aodi_wash_item.attributes.merge("_delete" => true)
      ]

      auth_put :batch_update, car_id: aodi_sold, car_fees: req_params

      expect(response_json[:data][:prepare_cost_yuan].to_i).to eq 47
    end

    it "修改收款信息" do
      req_params = [
        prepare_params(amount: 1, category: "receipt", item_name: nil)
      ]

      auth_put :batch_update, car_id: aodi_sold, car_fees: req_params

      expect(response_json[:data][:receipt_wan]).to eq 31
    end
  end
end
