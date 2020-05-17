require "rails_helper"

RSpec.describe V1::LoanBillsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi_loan_bill) { easy_loan_loan_bills(:aodi_gmc_loan) }
  let(:aodi) { cars(:aodi) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:icbc) { easy_loan_funder_companies(:icbc) }
  let(:tianche_finacing) { easy_loan_sp_companies(:tianche_sp) }

  before do
    EasyLoan::AccreditedRecord.create(
      company_id: tianche.id,
      funder_company_id: gmc.id,
      sp_company_id: tianche_finacing.id,
      limit_amount_wan: 100,
      in_use_amount_wan: 20
    )

    EasyLoan::AccreditedRecord.create(
      company_id: tianche.id,
      funder_company_id: icbc.id,
      sp_company_id: tianche_finacing.id,
      limit_amount_wan: 200,
      in_use_amount_wan: 10
    )

    login_user(zhangsan)
    give_authority(zhangsan, "融资管理")
  end

  def add_images_to_loan_bill(car)
    %w(行驶证 registration_license insurance).each do |image_type|
      car.acquisition_transfer.images.create!(location: image_type, url: image_type)
    end
  end

  describe "GET index" do
    it "得到这家公司里的所有库存融资记录" do
      aodi.create_cover(url: "cover-img-url")
      aodi.update!(cover_url: "cover-img-url")
      auth_get :index
      expect(response_json[:data].count).to eq 4
    end

    context "过滤" do
      it "可以根据品牌过滤" do
        auth_get :index, query: { car_brand_name_eq: "奥迪" }
        expect(response_json[:data].count).to eq 4
      end

      it "可以根据状态进行过滤" do
        auth_get :index, query: { state_in: %w(borrow_applied borrow_submitted) }
        expect(response_json[:data].count).to eq 4
      end
    end
  end

  describe "POST create" do
    context "对这家公司里某辆车进行借款" do
      it "生成一条借款记录" do
        allow(EasyLoanService::Lib).to receive(:estimate_car_price_wan).and_return(10)
        expect do
          auth_post :create, loan_bill: { car_id: aodi.id, funder_company_id: gmc.id }
        end.to change { EasyLoan::LoanBill.count }.by(1)

        loan_bill = EasyLoan::LoanBill.last
        expect(loan_bill.estimate_borrow_amount_wan).to be_present
      end

      it "生成一条操作记录"

      it "生成一条消息记录"
    end
  end

  describe "PUT return_apply" do
    before do
      aodi_loan_bill.update!(state: :borrow_confirmed)
    end

    it "变更状态为申请还款" do
      aodi_loan_bill.loan_bill_histories.create!(
        bill_state: "borrow_applied",
        user_id: zhangsan.id
      )
      auth_put :return_apply, id: aodi_loan_bill.id
      aodi_loan_bill.reload

      expect(aodi_loan_bill.state).to eq "return_applied"
      expect(aodi_loan_bill.state_history["return_applied_at"]).to be_present
    end
  end

  describe "GET show" do
    before do
      add_images_to_loan_bill(aodi)
    end

    it "展示这个借款单的详情" do
      aodi_loan_bill.loan_bill_histories.create!(
        user_id: zhangsan.id,
        bill_state: :borrow_applied
      )

      EasyLoanService::LoanBill.new(zhangsan, aodi_loan_bill).return_apply!
      auth_get :show, id: aodi_loan_bill.id
      expect(response_json[:data]).to be_present
      expect(response_json[:data][:loan_bill_histories].count).to eq 2
    end

    it "展示这个借款单的状态更改历史"
  end

  describe "GET check_accredited" do
    context "公司已授信" do
      before do
        allow(EasyLoanService::Lib).to receive(:estimate_car_price_wan).and_return(10)
        @accredited_record = tianche.accredited_records.create!(
          limit_amount_wan: 20,
          funder_company_id: gmc.id
        )
        aodi.loan_bill.destroy
      end

      it "如果该车辆信息不齐全，返回相应提示信息" do
        aodi.update!(vin: nil)
        aodi.acquisition_transfer.update!(key_count: nil)
        auth_get :check_accredited, car_id: aodi.id
        expect(response_json[:data]).to be_present
      end

      it "如果该车辆信息齐全，返回授信情况" do
        add_images_to_loan_bill(aodi)
        auth_get :check_accredited, car_id: aodi.id
        expect(response_json[:data]).to be_present
      end
    end
  end
end
