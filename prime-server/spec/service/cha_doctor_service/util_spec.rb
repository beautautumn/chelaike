require "rails_helper"

RSpec.describe ChaDoctorService::Util do
  let(:vin) { "LFPH3ACC7A1A61382" }

  before do
    travel_to Time.zone.parse("2016-11-4 12:30:34")
    allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")
  end

  describe ".signed_params(attrs)" do
    it "works" do
      attrs = { vin: vin }
      result = ChaDoctorService::Util.send(:signed_params, attrs)
      expect(result[:signature]).to eq "1Gy1ZFeqMNwP19To6n1OwO%2FgU7A%3D"
    end
  end
end
