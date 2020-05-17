require "rails_helper"

RSpec.describe AntQueen do
  describe "Brand" do
    it "returns brand list" do
      VCR.use_cassette("ant_queen_brand") do
        brand = AntQueen::Brand.get
        expect(brand).to be_present
      end
    end
  end
end
