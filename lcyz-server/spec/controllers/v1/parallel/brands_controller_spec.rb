require "rails_helper"

RSpec.describe V1::Parallel::BrandsController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { parallel_brands(:aodi) }
  let(:q7) { parallel_styles(:q7) }
  let(:service) { parallel_phones(:service) }
  let(:hyundai) { parallel_brands(:hyundai) }
  let(:benz) { parallel_brands(:benz) }

  before do
    login_user(zhangsan)
  end

  describe "GET #index" do
    it "returns parallels" do
      auth_get :index, type: "parallel"
      expect(response_json[:data].first[:name]).to eq aodi.name
      expect(response_json[:data].first[:brand_type]).to eq aodi.brand_type
    end

    it "filters brands with no styles" do
      auth_get :index, type: "parallel"
      result = response_json[:data].collect { |data| data[:name] }

      expect(result).not_to include benz.name
    end

    it "returns special" do
      auth_get :index, type: "special"
      expect(response_json[:data].first[:name]).to eq hyundai.name
      expect(response_json[:data].first[:brand_type]).to eq hyundai.brand_type
    end

    it "includes phone" do
      auth_get :index
      expect(response_json[:meta][:phone][:number]).to eq service.number
    end

    it "includes hot brands" do
      auth_get :index
      expect(response_json[:meta][:hot_brands].first[:name]).to eq aodi.name
    end

    it "search result" do
      auth_get :index, query: { name_cont: "奥" }
      expect(response_json[:data].first[:name]).to eq aodi.name
    end

    it "returns nil for search result" do
      auth_get :index, query: { name_cont: "大" }
      expect(response_json[:data]).to be_empty
    end
  end

  describe "GET #show" do
    it "returns result" do
      auth_get :show, id: aodi.id
      expect(response_json[:data][:name]).to eq aodi.name
    end

    it "contains first letter" do
      auth_get :show, id: aodi.id
      expect(response_json[:data][:first_letter]).to eq "A"
    end

    it "includes styles" do
      auth_get :show, id: aodi.id
      expect(response_json[:data][:styles].first[:name]).to eq q7.name
    end

    it "includes phone" do
      auth_get :show, id: aodi.id
      expect(response_json[:meta][:phone][:number]).to eq service.number
    end

    it "includes images" do
      auth_get :show, id: aodi.id
      expect(response_json[:data][:styles].first[:images]).to be_present
    end
  end
end
