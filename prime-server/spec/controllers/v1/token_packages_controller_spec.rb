require "rails_helper"

RSpec.describe V1::TokenPackagesController do
  fixtures :users, :token_packages

  let(:zhangsan) { users(:zhangsan) }
  let(:packages) { TokenPackage.all }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/token_packages" do
    it "returns token packages" do
      auth_get :index

      expect(response_json[:data].size).to eq packages.size
    end

    it "ordered by balance" do
      auth_get :index

      expect(response_json[:data].map { |i| i[:id] })
        .to eq packages.order(balance: :asc).map(&:id)
    end
  end

  describe "#buy" do
    let!(:package_a) { token_packages(:token_packages_a) }

    before do
      allow_any_instance_of(TokenPackagePolicy).to receive(:buy?).and_return(:true)
    end

    let(:params) do
      {
        order: {
          channel: "wx",
          token_type: :user
        },
        id: package_a.id
      }
    end

    it "returns 200" do
      VCR.use_cassette("api.pingxx.com/v1/charges") do
        auth_post :buy, params

        expect(response.status).to eq 200
      end
    end

    it "记录购买车币用户类型" do
      VCR.use_cassette("api.pingxx.com/v1/charges") do
        auth_post :buy, params

        order = Order.last
        expect(order.token_type).to eq "user"
      end
    end

    it "returns charge" do
      VCR.use_cassette("api.pingxx.com/v1/charges") do
        auth_post :buy, params
      end

      expect(response_json[:data]).not_to be_nil
      expect(response_json[:data][:id]).not_to be_nil
    end

    it "creates order" do
      VCR.use_cassette("api.pingxx.com/v1/charges") do
        expect do
          auth_post :buy, params
        end.to change { Order.count }.by(1)

        expect(Order.last.charge_id).to eq "ch_enzTi58KuPW9ujH0GCfn1SaH"
      end
    end
  end

  describe "#free_buy" do
    before do
      allow_any_instance_of(TokenPackagePolicy).to receive(:free_buy?).and_return(:true)
    end

    let(:params) do
      {
        order: {
          channel: "wx",
          amount: 1000
        }
      }
    end

    it "returns 200" do
      VCR.use_cassette("api.pingxx.com/v1/charges") do
        auth_post :free_buy, params
        expect(response.status).to eq 200
      end
    end

    it "returns charge" do
      VCR.use_cassette("api.pingxx.com/v1/charges") do
        auth_post :free_buy, params
      end

      expect(response_json[:data]).not_to be_nil
      expect(response_json[:data][:id]).not_to be_nil
    end

    it "creates order" do
      VCR.use_cassette("api.pingxx.com/v1/charges") do
        expect do
          auth_post :free_buy, params
        end.to change { Order.count }.by(1)

        expect(Order.last.charge_id).to eq "ch_enzTi58KuPW9ujH0GCfn1SaH"
      end
    end
  end
end
