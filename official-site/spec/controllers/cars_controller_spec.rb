# frozen_string_literal: true
require "rails_helper"

RSpec.describe CarsController, type: :controller do
  fixtures :all
  let(:paladin) { wechat_users(:paladin) }
  let(:human_paladin) { wechat_app_user_relations(:human_paladin) }

  describe "GET #index" do
    it "returns http success" do
      VCR.use_cassette "chelaike/car/all" do
        request.host = "forthehorde.com"
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #show" do
    it "returns http success" do
      VCR.use_cassette "chelaike/car/detail" do
        request.host = "forthehorde.com"
        get :show, params: { id: 4222 }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PUT #like" do
    before do
      mock_company
    end

    it "create record if not exist" do
      @request.session["union_id"] = paladin.union_id
      @request.session["open_id"] = human_paladin.open_id

      put :like, params: { id: 3 }
    end
  end

  describe "GET #alliance_similar" do
    it "returns http success" do
      VCR.use_cassette "chelaike/car/alliance_similar" do
        mock_descktop
        request.host = "forthehorde.com"
        get :alliance_similar, params: { id: 4222 }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #show" do
    it "展示车辆详情"
  end
end
