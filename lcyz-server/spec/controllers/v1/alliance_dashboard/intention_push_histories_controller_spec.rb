require "rails_helper"

RSpec.describe V1::AllianceDashboard::IntentionPushHistoriesController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:tianche) { companies(:tianche) }

  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:intention_level_b) { intention_levels(:intention_level_b) }

  let(:aodi_4s) { channels(:aodi_4s) }
  let(:aodi_5s) { channels(:aodi_5s) }
  let(:aodi) { cars(:aodi) }

  let(:doraemon_seeking_aodi) do
    intention = intentions(:doraemon_seeking_aodi)
    intention.update(
      creator: alliance_zhangsan,
      alliance_assignee_id: alliance_zhangsan.id,
      alliance_company_id: alliance_tianche.id
    )
    intention
  end

  before do
    give_authority(alliance_zhangsan, "求购客户管理")
    give_authority(alliance_zhangsan, "求购客户管理")
    login_user(alliance_zhangsan)
  end

  describe "POST create" do
    context "跟进状态为'继续跟进'" do
      it "创建一条这个意向的跟历史,类型是联盟" do
        expect do
          auth_post :create, intention_id: doraemon_seeking_aodi.id,
                             intention_push_history: {
                               state: "processing",
                               processing_time: Time.zone.now + 1.day,
                               checked: true,
                               intention_level_id: intention_level_b.id
                             }
        end.to change { doraemon_seeking_aodi.intention_push_histories.count }.by(1)
        doraemon_seeking_aodi.reload
        expect(doraemon_seeking_aodi.state).to eq "pending"
        expect(doraemon_seeking_aodi.alliance_state).to eq "processing"
      end
    end
  end
end
