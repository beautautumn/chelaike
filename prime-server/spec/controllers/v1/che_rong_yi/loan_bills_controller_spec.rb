require "rails_helper"

RSpec.describe V1::CheRongYi::LoanBillsController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  def mock_loan_accredited_record
    loan_accredited_record = CheRongYi::LoanAccreditedRecord.new(
      id: 1, shop_id: 1, allow_part_repay: true,
      funder_company_id: 1, single_car_rate: 70,
      sp_company_id: 1, limit_amount_wan: 50, in_use_amount_wan: 20
    )
    allow(CheRongYi::Api).to receive(:loan_accredited_records).and_return([loan_accredited_record])
  end

  def mock_loan_bill
    loan_bill = CheRongYi::LoanBill.new(
      id: 1, shop_id: 1, sp_company_id: 1,
      funder_company_id: 1, state: :borrowing,
      apply_code: "asdf", estimate_borrow_amount_wan: 20,
      borrowed_amount_wan: 20, remaining_amount_wan: 10
    )

    allow(CheRongYi::Api).to receive(:loan_bill).and_return(loan_bill)
  end

  # 创建还款单
  def mock_create_repayment_bill
    repayment_bill = CheRongYi::RepaymentBill.new(
      id: 1, loan_bill_id: 1, repayment_amount_wan: 5, state: :init
    )

    allow_any_instance_of(CheRongYi::RepaymentBillService).to receive(:create)
                                                                .and_return(
                                                                  repayment_bill
                                                                )
  end

  before do
    give_authority(zhangsan, "融资管理")
    login_user(zhangsan)
    aodi.update!(estimate_price_wan: 10)
  end

  describe "POST repay" do
    before do
      mock_loan_accredited_record
      mock_loan_bill
      mock_create_repayment_bill
    end

    it "创建还款单"

    it "判断剩下车辆估值是否大于未还款金额" do
      auth_post :repay, id: 1,
                repay_car_ids: [1, 2],
                remaining_car_ids: [aodi.id],
                repay_amount_wan: 10
      expect(reponse_json[:data])
    end
  end

  describe "GET post_check" do
    before do
      mock_loan_accredited_record
      mock_loan_bill
    end

    it "返回对应的授信信息" do
      auth_post :post_check,
                car_ids: [aodi.id]

      expect(response_json[:data]).to be_present
    end
  end

  def mock_create_loan_bill
    result = {
      loan_bill_id: 1,
      limit_amount_wan: 30.0,
      in_use_amount_wan: 10.0,
      estimate_borrow_amount_wan: 1.0,
      can_use_amount_wan: 20.0,
      can_borrow_amount_wan: 1.0,
      funder_company_id: 1,
      funder_company_name: "建行"
    }

    allow(CheRongYi::Api).to receive(:create_loan_bill).and_return(result)
  end

  describe "POST create" do
    it "创建借款单" do
      mock_create_loan_bill

      aodi.update!(shop_id: 12)
      auth_post :create, car_ids: [aodi.id],
                funder_company_id: 1,
                estimate_price_wan: 1
      expect(response_json[:data]).to be_present
    end
  end

  def mock_loan_bills
    result = {
      total_count: 15,
      per_page: 15,
      loan_bills: [
        CheRongYi::LoanBill.new(
          :id=>531,
          :shop_id=>100000,
          :sp_company_id=>1,
          :funder_company_id=>1,
          :state=>"borrow_applied",
          :apply_code=>"201803011741461000003",
          :created_at=>"2018-03-01 17:41:46",
          :updated_at=>"2018-03-01 17:41:46",
          :estimate_borrow_amount_cents=>10000000,
          :borrowed_amount_cents=>100,
          :estimate_borrow_amount_wan=>10.0,
          :borrowed_amount_wan=>0.0,
          :remaining_amount_wan=>0.0,
          :funder_company_name=>"建行",
          :latest_history_note=>"",
          :cars=>
          [{:id=>533,
            :brand_name=>"奥迪",
            :series_name=>"奥迪Q5",
            :style_name=>"2017款 40 TFSI 进取型",
            :company_id=>100000,
            :shop_id=>100000,
            :estimate_price_cents=>12000000,
            :licenced_at=>nil,
            :show_price_cents=>nil,
            :mileage=>22.0,
            :exterior_color=>"白色",
            :keys_count=>2,
            :vin=>"12333333333333333",
            :check_report_url=>nil,
            :check_report_type=>nil,
            :chelaike_car_id=>164,
            :images=>[
              {:id=>534,
               :url=>"http://env-pro.oss-cn-beijing.aliyuncs.com/images/45b88ea0-9123-4c27-9226-ad868b36ca17.jpg",
               :name=>nil,
               :location=>"left_anterior",
               :isCover=>true}]}]
        )
      ]
    }

    allow(CheRongYi::Api).to receive(:loan_bills).and_return(result)
  end

  describe "GET index" do
    it "得到这个车商所有的借款单列表" do
      mock_loan_bills
      auth_get :index, page: 1, per_page: 15,
               query: {
                 funder_company_id: nil, brand_name: nil,
                 state: nil, replace_history: "not_replace_history"
               }

      expect(response_json[:data]).to be_present
    end
  end

  def mock_loan_bill_detail
    loan_bill_detail = {
      :id=>54,
      :shop_id=>12,
      :sp_company_id=>1,
      :funder_company_id=>1,
      :state=>"reviewed",
      :apply_code=>"1",
      :created_at=>"2018-02-07 18:37:17",
      :updated_at=>"2018-02-11 17:33:41",
      :estimate_borrow_amount_cents=>10,
      :borrowed_amount_cents=>100,
      :estimate_borrow_amount_wan=>0.0,
      :borrowed_amount_wan=>0.0,
      :remaining_amount_wan=>10.0,
      :funder_company_name=>"建行",
      :latest_history_note=>"借款单修改测试",
      :cars=>
      [{:id=>2,
        :brand_name=>"大众",
        :series_name=>"22",
        :style_name=>nil,
        :company_id=>nil,
        :shop_id=>nil,
        :estimate_price_cents=>20000000,
        :licenced_at=>nil,
        :show_price_cents=>nil,
        :mileage=>nil,
        :exterior_color=>nil,
        :keys_count=>nil,
        :vin=>nil,
        :check_report_url=>nil,
        :check_report_type=>nil,
        :chelaike_car_id=>1,
        :images=>[{:id=>8, :url=>nil, :name=>nil, :location=>nil, :isCover=>false}]}],
      :histories=>
      [{:loan_bill_id=>54,
        :operator_id=>1,
        :operator_type=>"spCompany",
        :content_id=>54,
        :content_type=>"loan_bill",
        :content_state=>"reviewed",
        :created_at=>"2018-02-11 17:49:59",
        :bill_state=>"reviewed",
        :message=>"",
        :note=>"借款单修改测试"},
       {:loan_bill_id=>54,
        :operator_id=>1,
        :operator_type=>"spCompany",
        :content_id=>54,
        :content_type=>"loan_bill",
        :content_state=>"reviewed",
        :created_at=>"2018-02-11 17:33:41",
        :bill_state=>"reviewed",
        :message=>"",
        :note=>"借款单修改测试"},
       {:loan_bill_id=>54,
        :operator_id=>1,
        :operator_type=>"spCompany",
        :content_id=>54,
        :content_type=>"loan_bill",
        :content_state=>"borrow_applied",
        :created_at=>"2018-02-11 17:08:17",
        :bill_state=>"borrow_applied",
        :message=>"",
        :note=>"借款单修改测试"}]
    }

    loan_bill = CheRongYi::LoanBill.new(loan_bill_detail)
    allow(CheRongYi::Api).to receive(:loan_bill).and_return(loan_bill)
  end

  describe "GET show" do
    it "得到借款单详情" do
      mock_loan_bill_detail
      auth_get :show, id: 54
      expect(response_json[:data]).to be_present
    end
  end
end
