require "rails_helper"

RSpec.describe V1::PriceTagTemplatesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:fixture_zip) do
    fixture_file_upload("files/price_tag_demo.zip", "application/zip")
  end

  before do
    login_user(zhangsan)
  end

  describe "POST /api/v1/price_tag_templates" do
    it "create a new template by uploading zip file" do
      allow(SecureRandom).to receive(:hex).and_return("a")

      VCR.use_cassette("upload_price_tag_template") do
        auth_post :create, file: fixture_zip

        index_code = File.read("#{Rails.root}/spec/fixtures/files/price_tag_code.html")

        expect(PriceTagTemplate.last.code).to eq index_code.strip
      end
    end
  end
end
