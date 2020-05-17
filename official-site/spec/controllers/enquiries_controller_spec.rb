# frozen_string_literal: true
require "rails_helper"

RSpec.describe EnquiriesController, type: :controller do
  fixtures :all
  let(:paladin) { wechat_users(:paladin) }
  let(:human_paladin) { wechat_app_user_relations(:human_paladin) }

  before do
    @request.session["union_id"] = paladin.union_id
    @request.session["open_id"] = human_paladin.open_id
  end

  describe "POST create" do
    it "创建一条询价记录" do
      mock_company
      mock_car_subscribe
      phone = "123456789"
      name = "peter"

      expect do
        post :create, params: { enquiry: { car_id: 1, phone: phone, name: name } }, format: :json
      end.to change { Enquiry.count }.by 1
    end
  end
end
