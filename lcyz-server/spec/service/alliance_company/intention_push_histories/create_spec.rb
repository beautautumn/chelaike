require "rails_helper"

RSpec.describe AllianceCompanyService::IntentionPushHistories::Create do
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

  let(:push_history_params) do
    {
      state: "processing",
      processing_time: Time.zone.now + 1.day,
      checked: true,
      intention_level_id: intention_level_b.id
    }
  end

  let(:doraemon_seeking_aodi) do
    intention = intentions(:doraemon_seeking_aodi)
    intention.update(
      company_id: nil,
      assignee_id: nil,
      creator: alliance_zhangsan,
      alliance_assignee_id: alliance_zhangsan.id,
      alliance_company_id: alliance_tianche.id
    )
    intention
  end

  describe "#execute" do
    context "跟进状态为'继续跟进'" do
      it "创建一条这个意向的跟历史,类型是联盟" do
        service = AllianceCompanyService::IntentionPushHistories::Create.new(
          alliance_zhangsan, doraemon_seeking_aodi, push_history_params
        )

        push_history = service.execute.intention_push_history

        expect(push_history.class.name).to eq "AllianceIntentionPushHistory"
        expect(doraemon_seeking_aodi.latest_intention_push_history).to eq push_history
        expect(push_history.executor).to eq alliance_zhangsan
      end

      it "更新这个意向的相关状态" do
        service = AllianceCompanyService::IntentionPushHistories::Create.new(
          alliance_zhangsan, doraemon_seeking_aodi, push_history_params
        )

        service.execute.intention_push_history

        expect(doraemon_seeking_aodi.reload.state).to eq "processing"
      end
    end

    context "跟进状态为'预约看车'" do
      def interviewed_params
        {
          state: "interviewed",
          interviewed_time:  "2016-06-17 02:04:15",
          checked: true,
          note: "asdffdsa",
          car_ids: [aodi.id],
          intention_type: "seek"
        }
      end

      it "记录预约的车辆" do
        service = AllianceCompanyService::IntentionPushHistories::Create.new(
          alliance_zhangsan, doraemon_seeking_aodi, interviewed_params
        )

        push_history = service.execute.intention_push_history
        expect(push_history.intention_push_cars.map(&:car_id)).to include aodi.id
      end
    end
  end
end
