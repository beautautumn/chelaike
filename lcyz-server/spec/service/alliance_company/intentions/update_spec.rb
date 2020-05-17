require "rails_helper"

RSpec.describe AllianceCompanyService::Intentions::Update do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:tianche) { companies(:tianche) }
  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:aodi_5s) { channels(:aodi_5s) }
  let(:aodi) { cars(:aodi) }

  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:doraemon) { customers(:doraemon) }

  let(:seek_params) do
    {
      customer_name: "super man",
      customer_phone: "222",
      customer_phones: %w(191201 220001),
      gender: "male",
      province: "浙江",
      city: "杭州",
      intention_type: "seek",
      intention_level_id: intention_level_a.id,
      channel_id: aodi_4s.id,
      intention_note: "随便说点什么",
      seeking_cars: [
        {
          brand_name: "奥迪",
          series_name: "A6"
        },
        {
          brand_name: "大众",
          series_name: "宝来"
        }
      ],
      minimum_price_wan: 20,
      maximum_price_wan: 20
    }
  end

  before do
    give_authority(zhangsan, "求购客户管理")
    give_authority(lisi, "求购客户管理")
    Message.destroy_all
    doraemon_seeking_aodi.update!(
      assignee_id: nil,
      channel_id: aodi_4s.id,
      creator_id: alliance_zhangsan.id,
      creator_type: "AllianceCompany::User",
      shop_id: nil,
      company_id: nil
    )
  end

  describe "#update" do
    context "没有更新客户手机号" do
      it "更新意向信息" do
        service = AllianceCompanyService::Intentions::Update.new(
          alliance_zhangsan,
          doraemon_seeking_aodi,
          seek_params.merge(channel_id: aodi_5s.id)
        )
        service.update
        expect(doraemon_seeking_aodi.reload.channel).to eq aodi_5s
      end
    end

    context "更新客户手机号" do
      it "更新客户信息" do
        updated_phone = "111111"
        service = AllianceCompanyService::Intentions::Update.new(
          alliance_zhangsan,
          doraemon_seeking_aodi,
          seek_params.merge(channel_id: aodi_5s.id, customer_phone: updated_phone)
        )
        service.update
        expect(doraemon_seeking_aodi.reload.channel).to eq aodi_5s
        expect(doraemon.reload.phone).to eq updated_phone
      end
    end
  end
end
