require "rails_helper"

RSpec.describe EasyLoan::EnumerizeLocalesController, type: :controller do
  describe "GET index" do
    it "得到枚举值" do
      get :index
      expect(response_json[:data]).to be_present
    end
  end
end
