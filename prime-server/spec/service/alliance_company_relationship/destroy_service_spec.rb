require "rails_helper"

RSpec.describe AllianceCompanyRelationship::DestroyService do
  fixtures :all

  let(:hulk) { companies(:hulk) }
  let(:avengers) { alliances(:avengers) }
  let(:zhangsan) { users(:zhangsan) }
  let(:relationship) { alliance_company_relationships(:avengers_hulk) }
  let(:service) do
    AllianceCompanyRelationship::DestroyService.new(
      relationship,
      avengers,
      hulk.id,
      zhangsan
    )
  end

  describe "#execute" do
    it "退出联盟" do
      service.execute
      expect(
        AllianceCompanyRelationship.where(
          alliance_id: avengers.id, company_id: hulk.id)).to be_blank
    end

    it "清除联盟公司" do
      service.execute
      expect(hulk.alliance_company).to be_nil
    end

    it "creates operation record" do
      expect do
        service.execute
      end.to change { OperationRecord.count }.by(1)
    end
  end
end
