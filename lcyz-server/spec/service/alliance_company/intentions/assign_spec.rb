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

  let(:customer_phone) { "12344321" }

  let(:seek_params) do
    {
      customer_name: "super man",
      customer_phone: customer_phone,
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

  def customer
    @customer ||= Customer.create!(
      name: "customer_giant",
      phone: customer_phone
    )
  end

  def alliance_intention
    @intention ||= Intention.create!(
      seek_params.merge(
        state: :untreated,
        creator: alliance_zhangsan,
        customer_id: customer.id,
        alliance_assignee_id: alliance_zhangsan.id,
        alliance_company_id: alliance_tianche.id
      )
    )
  end

  describe "#assign" do
    before do
      customer.update(
        alliance_user_id: alliance_zhangsan.id,
        alliance_company_id: alliance_tianche.id
      )
    end

    it "把这几个意向与车商进行关联" do
      service = AllianceCompanyService::Intentions::Assign.new(
        alliance_zhangsan, [alliance_intention.id], tianche
      )
      service.assign
      expect(alliance_intention.reload.company_id).to eq tianche.id
      expect(alliance_intention.alliance_assigned_at).to be_present
    end

    it "把之前的指派人清空" do
      alliance_intention.update(assignee: zhangsan)

      service = AllianceCompanyService::Intentions::Assign.new(
        alliance_zhangsan, [alliance_intention.id], tianche
      )
      service.assign

      expect(alliance_intention.reload.assignee).to be_nil
    end

    describe "把相应的customer也分配给车商" do
      context "这个车商里已经有这个customer手机号" do
        it "更新这个customer信息" do
          tianche_customer = tianche.customers.create(
            name: "peter",
            phone: customer_phone,
            phones: [customer_phone]
          )

          service = AllianceCompanyService::Intentions::Assign.new(
            alliance_zhangsan, [alliance_intention.id], tianche
          )

          service.assign
          expect(customer.reload.name).to eq "customer_giant"
          expect(alliance_intention.reload.customer).to eq tianche_customer
        end
      end

      context "这个车商里没有这个customer" do
        it "把这个customer分配给这个车商" do
          service = AllianceCompanyService::Intentions::Assign.new(
            alliance_zhangsan, [alliance_intention.id], tianche
          )

          service.assign
          expect(customer.reload.company).to eq tianche
        end
      end
    end
  end
end
