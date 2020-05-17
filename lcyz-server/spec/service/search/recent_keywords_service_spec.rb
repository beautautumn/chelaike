require "rails_helper"

RSpec.describe Search::RecentKeywordsService do
  let(:service) { Search::RecentKeywordsService.new(:type, 1, limitation: 2) }

  describe ".append" do
    it "sets keyword to list" do
      service.append("abc")

      expect(service.all).to eq ["abc"]
    end

    it "drops old keyword if the size of list out of limitation" do
      service.append("aaa")
      service.append("bbb")
      service.append("ccc")

      expect(service.all).to eq %w(ccc bbb)
    end

    it "rescales the list" do
      service.append("aaa")
      service.append("bbb")
      service.append("aaa")

      expect(service.all).to eq %w(aaa bbb)
    end
  end
end
