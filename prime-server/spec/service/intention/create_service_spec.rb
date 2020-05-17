require "rails_helper"

RSpec.describe Intention::CreateService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:zhaoliu) { users(:zhaoliu) }
  let(:tianche) { companies(:tianche) }
  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:aodi_5s) { channels(:aodi_5s) }
  let(:doraemon) { customers(:doraemon) }
  let(:gian) { customers(:gian) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:jack_reservation) { car_reservations(:jack_reservation) }

  let(:seek_params) do
    {
      customer_name: "super man",
      customer_phone: "222",
      customer_phones: %w(191201 220001),
      gender: "male",
      province: "浙江",
      city: "杭州",
      intention_type: "seek",
      assignee_id: zhangsan.id,
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
    give_authority(zhangsan, "全部求购客户管理")
    doraemon.update(phone: "111")
  end

  describe "#execute" do
    context "坐席录入" do
      it "如果有这个手机号的用户的意向，状态是未完成，不能导入" do
        scope = Intention.intention_scope(zhangsan.company_id)
        request_params = seek_params.merge(
          customer_phone: doraemon.phone,
          assignee_id: nil
        )

        service = Intention::CreateService.new(zhangsan, scope, request_params)
        result = service.execute(check_intention: true)

        expect do
          result = service.execute(check_intention: true)
        end.to raise_error(Intention::CheckService::InvalidError)
      end
    end

    context "创建操作记录" do
      def service(user, req_params = { assignee_id: nil, state: :untreated })
        scope = Intention.intention_scope(zhangsan.company_id)
        request_params = seek_params.merge(
          customer_phone: doraemon.phone,
          assignee_id: nil,
          state: :untreated
        ).merge(req_params)

        Intention::CreateService.new(user, scope, request_params)
      end

      context "state is :untreated" do
        it "创建记录，内容为待分配" do
          result = service(zhangsan).execute(check_intention: true)

          intention = result.intention
          expect(intention.operation_records.count).to eq 1
        end
      end

      context "state is :pending" do
        context "有创建人" do
          it "不创建记录 if creator == assignee" do
            service = service(zhangsan, assignee_id: zhangsan.id, state: :pending)
            result = service.execute(check_intention: true)
            intention = result.intention
            expect(intention.operation_records.count).to eq 0
          end

          it "创建记录, 待跟进 if creator != assignee" do
            service = service(zhangsan, assignee_id: lisi.id, state: :pending)
            result = service.execute(check_intention: true)
            intention = result.intention
            expect(intention.operation_records.count).to eq 1
            record = intention.operation_records.first
            expect(record.operation_record_type).to eq "intention_reassigned"
          end
        end

        context "没有创建人，可能是从微店过来的意向" do
          it "创建记录，待跟进" do
            anonymous_user = User::Anonymous.new(company: lisi.company)
            service = service(anonymous_user, assignee_id: lisi.id, state: :pending)
            result = service.execute(check_intention: false)
            intention = result.intention
            expect(intention.operation_records.count).to eq 1
            record = intention.operation_records.first
            expect(record.operation_record_type).to eq "intention_reassigned"
          end
        end
      end
    end
  end
end
