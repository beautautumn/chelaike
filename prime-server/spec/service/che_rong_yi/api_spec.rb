require "rails_helper"

if ENV.key?("LOCAL_TEST")
  RSpec.describe CheRongYi::Api do
    fixtures :all

    let(:aodi) { cars(:aodi) }
    let(:pixar) { shops(:pixar) }

    before do
      WebMock.allow_net_connect!
      VCR.turn_off!
      aodi.update!(estimate_price_cents: 20_000_000)
    end

    describe ".create_loan_bill" do
      it "创建借款单" do
        params = {
          car_ids: [aodi.id], shop_id: 100000,
          funder_company_id: 1, estimate_borrow_amount_cents: 1_000_000
        }

        result = CheRongYi::Api.create_loan_bill(params)
        # {:limit_amount_wan=>30.0, :in_use_amount_wan=>10.0, :estimate_borrow_amount_wan=>1.0, :can_use_amount_wan=>20.0, :can_borrow_amount_wan=>1.0, :funder_company_id=>1, :funder_company_name=>"建行"}
      end
    end

    describe ".loan_accredited_records" do
      it "得到某车商所有的授信记录" do
        shop_id = 100000
        # shop_id = 55
        result = CheRongYi::Api.loan_accredited_records(shop_id)
        binding.pry
      end
    end

    describe ".loan_bill(id)" do
      it "根据id得到某条借款单详情" do
        loan_bill_id = 1656

        result = CheRongYi::Api.loan_bill(loan_bill_id)
        binding.pry
        expect(result.class.name).to eq "CheRongYi::LoanBill"
      end
    end

    describe ".loan_bills(params)" do
      it "得到某个车辆所有借款单" do
        params = {
          page: 0, per_page: 25,
          funder_company_id: nil, brand_name: "",
          shop_id: 167, state: nil, replaceHistory: nil
        }

        result = CheRongYi::Api.loan_bills(params)
        binding.pry
      end
    end

    describe ".create_replace_cars_bill(params)" do
      it "创建一条换车单" do
        allow_any_instance_of(Car::WeshopService).to receive(:official_company_domain).and_return("http://167.site.chelaike.com/")
        params = {
          loan_bill_id: 1706,
          will_replace_car_ids: [aodi.id],
          is_replaced_car_ids: [2],
          no_replace_car_ids: [3],
          current_amount_wan: 5,
          user_id: 1,
          shop_id: 167
        }

        result = CheRongYi::Api.create_replace_cars_bill(params)
        binding.pry
      end
    end

    describe ".replace_cars_bill" do
      it "得到一条换车单详情" do
        replace_cars_bill_id = 1684
        result = CheRongYi::Api.replace_cars_bill(replace_cars_bill_id)
        binding.pry
      end
    end

    describe ".create_repayment_bill" do
      it "创建一条还款单" do
        params = {
          car_ids: [101],
          loan_bill_id: 2001,
          repayment_amount_wan: 0.3
        }

        result = CheRongYi::Api.create_repayment_bill(params)
        binding.pry
      end
    end

    describe ".repayment_bill" do
      it "得到一条还款单详情" do
        repayment_bill_id = 2053
        result = CheRongYi::Api.repayment_bill(repayment_bill_id)
        binding.pry
      end
    end

    describe ".repayment_apply" do
      it "得到申请还款时得到一些基本信息" do
        loan_bill_id = 2095
        result = CheRongYi::Api.repayment_apply(loan_bill_id)
        binding.pry
      end
    end
  end
end
