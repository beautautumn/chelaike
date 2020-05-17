require "rails_helper"

RSpec.describe AllianceCompanyService::User::Login do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }

  describe "#login" do
    it "returns the user if valid" do
      service = AllianceCompanyService::User::Login.new(alliance_zhangsan.phone, "ZhangSan")
      logged_in_user = service.login
      expect(logged_in_user).to eq alliance_zhangsan
    end

    it "raises error if the password is wrong" do
      service = AllianceCompanyService::User::Login.new(alliance_zhangsan.phone, "")
      expect { service.login }.to raise_error(
        AllianceCompanyService::User::LoginError,
        "手机号码不存在或密码错误"
      )
    end

    it "raises error if can not find the user" do
      service = AllianceCompanyService::User::Login.new("", "")
      expect { service.login }.to raise_error(AllianceCompanyService::User::LoginError, "用户不存在")
    end
  end
end
