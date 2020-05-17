require "rails_helper"

RSpec.describe PublicPraiseService do
  include PublicPraiseHelper

  before do
    mock_requests
  end

  describe "#execute" do
    it "pulls data and store data" do
      service = PublicPraiseService.new("奥迪", "奥迪A3", "2016款 Sportback 35 TFSI 进取型")
      sumup_record = service.execute

      expect(sumup_record).to be_persisted

      expect(sumup_record.records.size).to eq 1
    end
  end
end
