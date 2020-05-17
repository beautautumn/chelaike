require "rails_helper"

RSpec.describe V1::AllianceInvitationsController do
  fixtures :all

  let(:git) { users(:git) }
  let(:avengers) { alliances(:avengers) }
  let(:gcd) { alliances(:gcd) }
  let(:tianche_invitation) { alliance_invitations(:tianche_invitation) }

  before do
    give_authority(git, "联盟管理")
    login_user(git)
  end

  describe "POST /api/v1/alliances/:id/alliance_invitations" do
    it "邀请其他公司进入联盟" do
      gcd.update_columns(owner_id: git.company_id)

      auth_post :create, alliance_id: gcd.id, company_ids: [git.id]

      invitation = AllianceInvitation.find_by(
        company_id: git.id, alliance_id: gcd.id, state: "pending"
      )

      expect(invitation).to be_present
      expect(invitation.operation_record_id).to be_present
      expect(invitation.operation_record.messages["state"]).to eq "unprocessed"
    end

    it "已加入联盟的公司不能邀请" do
      avengers_owner = avengers.owner_id
      avengers.update_columns(owner_id: git.company_id)

      auth_post :create, alliance_id: avengers.id, company_ids: [avengers_owner]

      expect(response_json[:errors]).to be_present
    end
  end

  describe "POST /api/v1/alliances/:id/alliance_invitations/agree" do
    it "同意加入复仇者联盟" do
      auth_post :agree, alliance_id: avengers.id

      expect(avengers.companies.find(git.company_id)).to be_present
      expect(tianche_invitation.operation_record.messages["state"]).to eq "agreed"
    end
  end

  describe "POST /api/v1/alliances/:id/alliance_invitations/disagree" do
    it "不同意加入复仇者联盟" do
      auth_post :disagree, alliance_id: avengers.id

      expect(avengers.companies.where(id: git.company_id).size).to eq 0
      expect(tianche_invitation.operation_record.messages["state"]).to eq "disagreed"
    end
  end

  describe "POST /api/v1/alliances/:id/alliance_invitations/agree" do
    it "操作已被处理过的邀请将得到403" do
      auth_post :agree, alliance_id: gcd.id

      expect(response.status).to eq 403
    end
  end
end
