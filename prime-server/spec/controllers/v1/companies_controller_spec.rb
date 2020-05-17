require "rails_helper"

RSpec.describe V1::CompaniesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:avengers) { alliances(:avengers) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/companies" do
    before do
      give_authority(zhangsan, "联盟管理")
    end
    it "获取所有公司信息" do
      auth_get :index

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/company/customers" do
    before do
      give_authority(zhangsan, "代办客户预定/出库")
    end
    it "获取所有客户信息" do
      auth_get :customers

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/company/own_brand_alliances" do
    it "lists all alliances which has own_brand_tag" do
      auth_get :own_brand_alliances, id: tianche.id

      result = response_json[:data].collect { |data| data[:id] }
      expect(result).to include avengers.id
    end
  end

  describe "GET /api/v1/company" do
    it "获取公司信息" do
      auth_get :show

      expect(response_json[:data][:name]).to eq "天车二手车"
      expect(response_json[:data][:in_alliances]).to be_truthy
    end
  end

  describe "PUT /api/v1/company/automated_stock_number" do
    before do
      give_authority(zhangsan, "业务设置")
    end
    it "updates automated_stock_number rule" do
      auth_put :automated_stock_number, company: {
        settings: {
          automated_stock_number: true,
          automated_stock_number_prefix: "YC",
          automated_stock_number_start: 10_000
        }
      }

      result = {
        data: {
          automated_stock_number: true,
          automated_stock_number_prefix: "YC",
          automated_stock_number_start: 10_000,
          stock_number_by_vin: false,
          created_at: iso8601_format("2015-01-10")
        }
      }
      expect(response_json).to eq result
    end
  end

  describe "PUT /api/v1/company/unified_management" do
    before do
      give_authority(zhangsan, "业务设置")
    end

    it "updates unified_management" do
      auth_put :unified_management, company: {
        settings: { unified_management: false }
      }

      expect(zhangsan.company.reload.unified_management).to be_falsy
    end
  end

  describe "GET /api/v1/company/financial_configuration" do
    before do
      give_authority(zhangsan, "财务管理")
      login_user(zhangsan)
    end

    it "gets financial_configuration" do
      auth_get :financial_configuration
      expect(response_json[:data]).to be_present
    end

    it_should_behave_like "permission check", "财务管理" do
      let(:request_query) do
        auth_get :financial_configuration
      end
    end
  end

  describe "PUT /api/v1/company/financial_configuration" do
    before do
      give_authority(zhangsan, "财务管理")
      login_user(zhangsan)
    end

    it "updates financial_configuration" do
      auth_put :update_financial_configuration, company: {
        financial_configuration: { fund_rate: 5.0 }
      }

      expect(zhangsan.company.reload.fund_rate).to eq 5.0
    end

    it_should_behave_like "permission check", "财务管理" do
      let(:request_query) do
        auth_put :update_financial_configuration, company: {
          financial_configuration: { fund_rate: 5.0 }
        }
      end
    end
  end

  describe "PUT /api/v1/company" do
    before do
      give_authority(zhangsan, "公司信息设置")
    end
    it "updates company info" do
      auth_put :update, id: tianche.id,
                        company: {
                          name: "哈哈二手车",
                          contact: "联系人",
                          contact_mobile: "110",
                          acquisition_mobile: "123",
                          sale_mobile: "321",
                          logo: "aa.avi",
                          province: "浙江省",
                          city: "杭州市",
                          street: "xxxx街道",
                          banners: ["abc.com"],
                          qrcode: "abc.com"
                        }

      expect(tianche.reload.name).to eq "哈哈二手车"
      expect(tianche.logo).to eq "aa.avi"
      expect(tianche.qrcode).to eq "abc.com"
      expect(tianche.banners).to eq ["abc.com"]
    end
  end

  describe "GET /api/v1/company/official_website_url" do
    it "return official_website_url" do
      VCR.use_cassette("official_website_url") do
        auth_get :official_website_url

        expect(response_json[:data]).to have_key(:official_website_url)
      end
    end
  end

  describe "删除公司" do
    it "关联的用户信息也被删除" do
      tianche.destroy

      expect { User.find(zhangsan.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET shops" do
    it "得到这个商家所有的店铺" do
      auth_get :shops, id: tianche
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET check_accredited" do
    it "公司已授信,返回ok" do
      tianche.accredited_records.create!(
        limit_amount_wan: 20,
        funder_company_id: gmc.id
      )

      auth_get :check_accredited
      expect(response_json[:data]).to be_present
    end

    it "公司未授信，返回提示内容" do
      auth_get :check_accredited
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET cities_name" do
    it "得到城市名" do
      auth_get :cities_name
      expect(response_json[:data]).to be_present
    end
  end
end
