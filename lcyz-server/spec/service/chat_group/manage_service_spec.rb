require "rails_helper"

RSpec.describe ChatGroup::ManageService do
  fixtures :all

  let(:avengers) { alliances(:avengers) }
  let(:tianche) { companies(:tianche) }
  let(:github) { companies(:github) }

  describe "#execute" do
    context "create" do
      before do
        @service = ChatGroup::ManageService.new(
          "enable",
          github,
          "sale"
        )
      end

      it "create chat group" do
        VCR.use_cassette("rongcould/chat_group") do
          @service.execute
        end
        record = github.chat_groups.find_by(group_type: :sale)
        expect(record).to be_present
      end
    end

    context "update" do
      before do
        @service = ChatGroup::ManageService.new(
          "disable",
          tianche,
          "sale"
        )
      end

      it "disable chat group" do
        @service.execute
        record = tianche.chat_groups.find_by(group_type: :sale)
        expect(record.state).to eql "disable"
      end
    end
  end
end
