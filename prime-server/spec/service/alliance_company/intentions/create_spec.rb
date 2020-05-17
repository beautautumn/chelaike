require "rails_helper"

RSpec.describe AllianceCompanyService::Intentions::Create do
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

  def service
    seek_params[:state] = :untreated

    AllianceCompanyService::Intentions::Create.new(
      alliance_zhangsan, seek_params.merge!(state: :untreated)
    )
  end

  before do
    give_authority(zhangsan, "求购客户管理")
    give_authority(lisi, "求购客户管理")
    Message.destroy_all
  end

  describe "#create" do
    it "创建客户，标记为联盟" do
      Sidekiq::Testing.inline! do
        expect { service.create }.to change { Customer.count }.by(1)
        customer = Customer.last
        expect(customer.from_alliance_company?).to be_truthy
      end
    end

    it "不需要创建消息" do
      Sidekiq::Testing.inline! do
        service.create
        expect(Message.count).to eq 0
      end
    end

    it "创建这个意向,标记为联盟" do
      Sidekiq::Testing.inline! do
        result = service.create
        intention = result.intention
        expect(intention).to be_persisted
        expect(intention.from_alliance_company?).to be_truthy
      end
    end

    it "新创建的意向，指派人是这个创建人" do
      Sidekiq::Testing.inline! do
        result = service.create
        intention = result.intention
        expect(intention.alliance_assignee).to eq alliance_zhangsan
      end
    end
  end
end
