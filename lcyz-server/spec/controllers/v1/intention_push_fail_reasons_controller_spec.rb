require "rails_helper"

RSpec.describe V1::IntentionPushFailReasonsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:fail_reason_other_place) { intention_push_fail_reasons(:fail_reason_other_place) }
  let(:fail_reason_sold_out) { intention_push_fail_reasons(:fail_reason_sold_out) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    IntentionPushFailReason.update_all(company_id: tianche.id)
    zhangsan.update!(company_id: tianche.id)
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET index" do
    it "得到这家公司里所有的战败原因" do
      auth_get :index
      expect(response_json[:data].count).to eq 2
    end
  end

  describe "POST create" do
    it "为某公司创建一条战败原因" do
      expect do
        auth_post :create, fail_reason:
                             {
                               name: "fail reason",
                               note: "unknown"
                             }
      end.to change { IntentionPushFailReason.count }.by 1

      fail_reason = IntentionPushFailReason.last
      expect(fail_reason.company).to eq tianche
      expect(tianche.intention_push_fail_reasons).to include fail_reason
    end
  end

  describe "PUT update" do
    it "更改一条战败原因记录" do
      auth_put :update,
               id: fail_reason_other_place.id,
               fail_reason: { name: "good", note: "new note" }

      expect(fail_reason_other_place.reload.name).to eq "good"
    end
  end

  describe "GET app_index" do
    it "不需要权限得到所有原因" do
      auth_get :app_index
      expect(response_json[:data].count).to eq 2
    end
  end
end
