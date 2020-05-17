require "rails_helper"

RSpec.describe Intention::UpdateService do
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
  let(:import_intentions) do
    fixture_file_upload("files/import_intentions.xls", "application/vnd.ms-excel")
  end
  let(:import_intentions_invalid) do
    fixture_file_upload("files/import_intentions_invalid.xls", "application/vnd.ms-excel")
  end

  let(:customer_phone) { "222" }
  let(:seek_params) do
    {
      customer_name: "super man",
      customer_phone: customer_phone,
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

  describe "#execute" do
    context "有客户管理权限" do
      before do
        give_authority(zhangsan, "全部客户管理")
      end

      context "参数里没有customer_id" do
        before do
          @seek_params = { assignee_id: lisi.id }
        end

        it "可以正常更改归属人" do
          service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, @seek_params)
          service.execute
          expect(doraemon_seeking_aodi.reload.assignee).to eq lisi
        end
      end

      context "参数里含有customer_id" do
        before do
          @seek_params = seek_params.merge(customer_id: doraemon.id)
        end

        context "归属人不是本人" do
          before do
            doraemon_seeking_aodi.update(assignee_id: zhaoliu.id)
            doraemon.update(phone: customer_phone)
          end

          context "更改归属人" do
            before do
              @seek_params = @seek_params.merge(assignee_id: lisi.id)
            end

            it "未更改手机号，应该可以更新归属人" do
              service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, @seek_params)
              service.execute
              expect(doraemon_seeking_aodi.reload.assignee_id).to eq lisi.id
            end

            it "更改手机号，归属人跟客户手机号同时被更改" do
              customer_phone = "12344321"
              @seek_params[:customer_phone] = customer_phone
              service = Intention::UpdateService.new(
                zhangsan,
                doraemon_seeking_aodi,
                @seek_params
              )
              service.execute
              expect(doraemon_seeking_aodi.reload.assignee_id).to eq lisi.id
              expect(doraemon.reload.phone).to eq customer_phone
            end
          end
        end

        context "没有归属人" do
          before do
            doraemon_seeking_aodi.update(assignee_id: nil)
            doraemon.update(phone: customer_phone)
          end

          it "可以更改这个意向的归属人" do
            @seek_params = @seek_params.merge(assignee_id: lisi.id)
            service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, @seek_params)
            service.execute
            expect(doraemon_seeking_aodi.reload.assignee_id).to eq lisi.id
          end

          it "可以更改customer的手机号" do
            customer_phone =  "12344321"
            @seek_params[:customer_phone] = customer_phone
            service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, @seek_params)
            service.execute
            expect(doraemon.reload.phone).to eq customer_phone
          end
        end
      end

      context "修改到期提醒日期" do
        before do
          # give_auhority(zhangsan, "全部客户管理")
          ExpirationSetting.init(tianche)
          travel_to Time.zone.parse("2017-2-23")
        end

        it "生成相应的 ExpirationNotification" do
          params = seek_params.merge(
            annual_inspection_notify_date: "2017-2-25",
            insurance_notify_date: "2017-5-25",
            mortgage_notify_date: "2017-7-23"
          )

          service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, params)
          expect do
            service.execute
          end.to change { ExpirationNotification.count }.by 3
        end
      end
    end

    context "普通销售人员" do
      before do
        deprive_authority(zhangsan, "全部客户管理")
      end

      context "参数里没有customer_id" do
        before do
          @seek_params = { assignee_id: lisi.id }
        end

        it "不能更改归属人" do
          service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, @seek_params)
          expect do
            service.execute
          end.to raise_error(Intention::UpdateService::ForbiddenActionError, "没有权限更改归属人")
        end
      end

      context "参数里含有customer_id" do
        before do
          @seek_params = seek_params.merge(customer_id: doraemon.id)
        end

        context "更改归属人" do
          before do
            @seek_params = @seek_params.merge(assignee_id: lisi.id)
          end

          it "没有权限操作" do
            service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, @seek_params)
            expect do
              service.execute
            end.to raise_error(Intention::UpdateService::ForbiddenActionError)
          end
        end

        context "不更改归属人" do
          before do
            @seek_params = @seek_params.merge(customer_phone: "12344321")
          end

          it "可以更改用户手机号" do
            service = Intention::UpdateService.new(zhangsan, doraemon_seeking_aodi, @seek_params)
            service.execute
            expect(doraemon.reload.phone).to eq "12344321"
          end
        end
      end
    end
  end
end
