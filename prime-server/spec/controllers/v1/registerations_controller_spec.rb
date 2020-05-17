require "rails_helper"

RSpec.describe V1::RegistrationsController do
  fixtures :all

  let(:phone) { "18668237888" }
  let(:name) { "DavidFincher" }
  let(:password) { "ILoveYourFilms." }

  let(:company_name) { "alibaba" }
  let(:contact) { "Mark" }

  describe "POST /api/v1/registrations" do
    it "注册新用户" do
      allow(SecureRandom).to receive(:hex).and_return("a")

      VCR.use_cassette("registrations", preserve_exact_body_bytes: true) do
        post :create,
             user: {
               name: name,
               password: password,
               phone: phone
             },
             company: {
               province: "浙江省",
               city: "杭州市",
               district: "拱墅区",
               name: company_name,
               contact: contact
             }

        company = Company.find_by(name: company_name)
        user = User.find_by(phone: phone)

        expect_result = {
          contact: contact,
          id: response_json[:data][:id],
          token: response_json[:data][:token]
        }

        result = {
          contact: company.contact,
          id: company.owner_id,
          token: user.token
        }

        expect(result).to eq expect_result
        expect(company.authority_roles.size).to eq 7
        expect(user.authority_roles.first.name).to eq "老板"
        expect(company.md5_name).to eq Digest::MD5.hexdigest(company_name)
        expect(company.intention_levels.size).to eq 5
      end
    end

    it "手机号已存在" do
      post :create,
           user: {
             name: name,
             password: password,
             phone: "18668237883"
           },
           company: {
             province: "浙江省",
             city: "杭州市",
             district: "拱墅区",
             name: company_name,
             contact: contact
           }

      expect(response_json[:errors][:user][:phone]).not_to be_empty
    end

    it "公司名已存在" do
      post :create,
           user: {
             name: name,
             password: password,
             phone: "18668237885"
           },
           company: {
             province: "浙江省",
             city: "杭州市",
             district: "拱墅区",
             name: "天车二手车",
             contact: contact
           }

      expect(response_json[:errors][:company][:name]).not_to be_empty
    end
  end
end
