require "rails_helper"

RSpec.describe Company::OfficialWebsiteUrlService do
  fixtures :all

  let(:tianche) do
    company = companies(:tianche)

    company.id = 4764
    company
  end

  describe "#execute" do
    before do
      allow(Company).to receive(:find).and_return(tianche)
    end

    it "changes official_website_url" do
      VCR.use_cassette("official_website_url") do
        expect(tianche.read_attribute(:official_website_url)).to be_blank

        Company::OfficialWebsiteUrlService.new.execute

        expect(tianche.reload.official_website_url).to be_present
      end
    end
  end
end
