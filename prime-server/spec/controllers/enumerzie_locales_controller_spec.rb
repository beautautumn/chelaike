require "rails_helper"

RSpec.describe EnumerizeLocalesController do
  # fixtures :all

  describe "GET /api/enumerize_locales" do
    it "show all locales for enumerize" do
      get :index

      expect(response_json[:data]).to have_key(:car)
    end
  end

  describe "GET app" do
    it "得到java需要的格式" do
      get :app

      expect(response_json[:data]).to have_key(:car)
    end
  end
end
