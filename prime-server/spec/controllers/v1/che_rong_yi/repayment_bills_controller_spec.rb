require "rails_helper"

RSpec.describe V1::CheRongYi::RepaymentBillsController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:aodi1) { cars(:aodi_1) }
  let(:aodi2) { cars(:aodi_2) }

  before do
    give_authority(zhangsan, "融资管理")
    login_user(zhangsan)
    aodi.update!(estimate_price_wan: 10)
  end

  def mock_create_repayment_bill
    result = CheRongYi::RepaymentBill.new(
      id: 10
    )

    allow(CheRongYi::Api).to receive(:create_repayment_bill).and_return(result)
  end

  describe "POST create" do
    it "创建一条还款单" do
      mock_create_repayment_bill
      auth_post :create, car_ids: [aodi.id],
                loan_bill_id: 1,
                repayment_amount_wan: 10

      binding.pry
      expect(response_json[:data]).to be_present
    end
  end

  def mock_repayment_bill_detail
    repayment_bill_detail = {
      :id=>2053,
      :loan_bill_id=>2040,
      :funder_company_id=>1,
      :sp_company_id=>1,
      :debtor_id=>227,
      :apply_code=>"201803101441570020406",
      :funder_company_name=>"建行",
      :created_at=>"2018-03-10 14:41:57",
      :updated_at=>"2018-03-10 14:41:57",
      :allow_part_repay=>false,
      :credit_balance_amount_wan=>50.0,
      :repayment_amount_wan=>0.3,
      :current_use_amount_wan=>0.8,
      :cars=>
      [{:id=>2042,
        :brand_name=>"奥迪",
        :series_name=>"一汽-大众奥迪",
        :style_name=>"2016款 Sportback 35 TFSI 进取型",
        :company_id=>100000,
        :shop_id=>100000,
        :estimate_price_cents=>2000000,
        :licenced_at=>nil,
        :show_price_cents=>nil,
        :mileage=>22.0,
        :exterior_color=>"白色",
        :keys_count=>2,
        :vin=>"12333333333333333",
        :check_report_url=>nil,
        :check_report_type=>nil,
        :chelaike_car_id=>111,
        :images=>
        [{:id=>2043, :url=>"http://prime-server-market.oss-cn-hangzhou.aliyuncs.com/images/CF66C152-10BA-4C91-B39F-D2C49291B189.jpg", :name=>nil, :location=>"left_anterior", :isCover=>true},
         {:id=>2044, :url=>"http://prime-server-market.oss-cn-hangzhou.aliyuncs.com/images/B41B66A9-FF68-4BEB-BDE9-D59A6A66A116.jpg", :name=>nil, :location=>"", :isCover=>false}]}],
      :histories=>
      [{:loan_bill_id=>2040,
        :operator_id=>227,
        :operator_type=>"debtor",
        :content_id=>2053,
        :content_type=>"repayment_bill",
        :content_state=>"return_applied",
        :created_at=>"2018-03-10 14:41:57",
        :bill_state=>"return_applied",
        :message=>"0.30万",
        :note=>""}]
    }

    repayment_bill = CheRongYi::RepaymentBill.new(repayment_bill_detail)
    allow(CheRongYi::Api).to receive(:repayment_bill).and_return(repayment_bill)
    allow(CheRongYi::Api).to receive(:repayment_apply).and_return(repayment_bill)
  end

  describe "GET show" do
    it "得到某条借款单详情" do
      mock_repayment_bill_detail
      auth_get :show, id: 1
      binding.pry

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET apply" do
    it "得到还款时一些基本信息" do
      mock_repayment_bill_detail
      auth_get :apply, id: 1
      binding.pry
      expect(response_json[:data]).to be_present
    end
  end
end
