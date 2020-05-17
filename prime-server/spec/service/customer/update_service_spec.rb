require "rails_helper"

RSpec.describe Customer::UpdateService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:nolan) { users(:nolan) }
  let(:cruise) { customers(:cruise) }
  let(:cruise_sell_aodi) { intentions(:cruise_sell_aodi) }
  let(:cruise_birth_date) { expiration_notifications(:cruise_birth_date) }

  describe "#update" do
    before do
      ExpirationSetting.init(tianche)
    end

    context "参数里没有 memory_dates字段" do
      it "正常更新其他字段" do
        bale_name = "bale"

        params = {
          name: bale_name,
          note: "我是克里斯蒂安贝尔",
          phones: %w(18668244444 18668244442),
          phone: "18668243444",
          avatar: "I'm a avatar"
        }

        service = Customer::UpdateService.new(zhangsan, cruise)
        service.update(params)

        cruise.reload
        expect(cruise.name).to eq bale_name
        expect(cruise.phone).to eq "18668243444"
      end
    end

    context "参数里有 memory_dates字段" do
      before do
        travel_to Time.zone.parse("2017-2-22")
      end

      def customer_params
        {
          name: "bale",
          memory_dates: [
            { name: "生日", date: "02-22" },
            { name: "爱人生日", date: "03-06" },
            { name: "asdf", date: "04-07" }
          ]
        }
      end

      it "保存memory_dates信息" do
        service = Customer::UpdateService.new(zhangsan, cruise)
        service.update(customer_params)

        cruise.reload
        expect(cruise.name).to eq "bale"
        expect(cruise.memory_dates).to be_present
      end

      it "创建一条Expirationnotification记录" do
        service = Customer::UpdateService.new(zhangsan, cruise)
        expect do
          service.update(customer_params)
        end.to change { ExpirationNotification.count }.by 3
      end

      it "跟Expirationnotification记录建立关联" do
        service = Customer::UpdateService.new(zhangsan, cruise)
        service.update(customer_params)

        first_date = cruise.memory_dates.first
        expect(first_date.fetch("notification_id")).to be_present
      end
    end

    context "更新提醒时间" do
      before do
        ExpirationSetting.init(tianche)
        cruise.update!(memory_dates: [
                         {
                           name: "生日",
                           date: "3-6",
                           notification_id: cruise_birth_date.id
                         }
                       ])
      end

      def customer_params
        {
          name: "bale",
          memory_dates: [
            { name: "生日", date: "4-1", notification_id: cruise_birth_date.id },
            { name: "爱人生日", date: "3-6" },
            { name: "asdf", date: "4-7" }
          ]
        }
      end

      it "如果有提醒ID，更新已有提醒里的notify_date" do
        service = Customer::UpdateService.new(zhangsan, cruise)
        service.update(customer_params)

        cruise.reload
        expect(cruise.name).to eq "bale"
        expect(cruise_birth_date.reload.notify_date).to eq Date.parse("2017-4-1")
      end
    end
  end
end
