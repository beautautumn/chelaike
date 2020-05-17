# frozen_string_literal: true
require "rails_helper"

RSpec.describe AdvertisementsController, type: :controller do
  fixtures :all
  let(:human) { tenants(:human) }

  describe "GET index" do
    it "gets ads with subdomain" do
      @request.host = "human.test.host"
      get :index
      expect(response).to be_present
    end

    it "gets ads with top level domain" do
      @request.host = "www.forthehorde.com"
      get :index
      expect(response).to be_present
    end
  end
end
