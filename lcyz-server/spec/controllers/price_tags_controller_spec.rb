require "rails_helper"

RSpec.describe PriceTagsController do
  fixtures :all

  let(:aodi) { cars(:aodi) }
  let(:tianche) { companies(:tianche) }
  let(:default_template) { price_tag_templates(:default_template) }

  describe "show action" do
    it "renders tag template" do
      allow(Wechat::Mp::Qrcode).to receive(:generate).and_return(
        "http://im.qrcode.wechat"
      )

      VCR.use_cassette("tag_template") do
        get :show, car_id: aodi.id, company_id: tianche.id
      end

      result = File.read("#{Rails.root}/spec/fixtures/files/price_tag_code.html")
                   .gsub("{{ car_id }}", aodi.id.to_s)
                   .gsub("{{ star }}", "")

      expect(response.body.squish).to eq result.squish
    end

    it "renders text for no template error" do
      default_template.destroy
      get :show, car_id: aodi.id, company_id: tianche.id

      expect(response.body).to eq "请上传价签模板"
    end

    it "renders text for template syntax error" do
      allow(Liquid::Template).to receive(:parse) { raise "syntax error" }

      get :show, car_id: aodi.id, company_id: tianche.id
      expect(response.body).to start_with "价签模板语法错误"
    end
  end
end
