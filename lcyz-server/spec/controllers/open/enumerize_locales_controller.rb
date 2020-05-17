require "rails_helper"

RSpec.describe Open::EnumerizeLocalesController do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  describe "GET /api/open/v1/enumerize_locales" do
    before do
      access_app(tianche)
    end

    it "return a hash" do
      open_get :index

      expect(response_json[:data]).to be_present
    end
  end
end
