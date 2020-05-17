require "rails_helper"

RSpec.describe V1::RecentSearchKeywordsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/recent_search_keyword" do
    before do
      Search::RecentKeywordsService.new(:cars_in_stock, zhangsan.id).append("abc")
    end

    it "shows recent search keywords" do
      auth_get :show, type: "cars_in_stock"

      expect(response_json[:data]).to eq ["abc"]
    end
  end
end
