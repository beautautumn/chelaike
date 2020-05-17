require "rails_helper"

RSpec.describe V1::IntentionsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:wangwu) { users(:wangwu) }
  let(:tianche) { companies(:tianche) }
  let(:git) { users(:git) }
  let(:aodi) { cars(:aodi) }
  let(:github) { companies(:github) }
  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:aodi_5s) { channels(:aodi_5s) }
  let(:doraemon) { customers(:doraemon) }
  let(:gian) { customers(:gian) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:gian_seeking_aodi) { intentions(:gian_seeking_aodi) }
  let(:cruise_sell_aodi) { intentions(:cruise_sell_aodi) }
  let(:cruise_seeking_bmw) { intentions(:cruise_seeking_bmw) }
  let(:jack_reservation) { car_reservations(:jack_reservation) }
  let(:cruise_birth_date) { expiration_notifications(:cruise_birth_date) }
  let(:import_intentions) do
    fixture_file_upload("files/import_intentions.xls", "application/vnd.ms-excel")
  end
  let(:import_intentions_invalid) do
    fixture_file_upload("files/import_intentions_invalid.xls", "application/vnd.ms-excel")
  end

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }

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

  let(:sale_params) do
    {
      customer_name: "super man",
      customer_phone: "111",
      customer_phones: %w(10000 220000),
      gender: "male",
      brand_name: "奥迪",
      series_name: "A6",
      mileage: 110.2,
      licensed_at: "2015-01-10",
      color: "白色",
      minimum_price_wan: 20,
      maximum_price_wan: 20,
      intention_note: "aabbcc",
      assignee_id: zhangsan.id,
      province: "浙江",
      city: "杭州",
      intention_type: "sale",
      intention_level_id: intention_level_a.id,
      channel_id: aodi_4s.id,
      state: "pending",
      interviewed_time: "2015-01-12",
      consigned_at: "2015-01-12"
    }
  end

  before do
    login_user(zhangsan)
  end

  describe "POST /api/v1/intentions" do
    context "create a untreated intention" do
      before do
        give_authority(zhangsan, "求购客户管理")
        give_authority(lisi, "求购客户管理")

        @seek_params = seek_params.merge(state: :untreated)
      end

      # 实际上是正常的
      # it "creates messages for users" do
      #   VCR.use_cassette("ip_address") do
      #     Sidekiq::Testing.inline! do
      #       expect do
      #         auth_post :create, intention: @seek_params
      #       end.to change { Message.count }.by(2)
      #     end
      #   end
      # end
    end

    context "create seek intention" do
      it "creates a record" do
        expect do
          auth_post :create, intention: seek_params
        end.to change { tianche.intentions.count }.by(1)
      end

      it "creates customer" do
        expect do
          auth_post :create, intention: seek_params
        end.to change { Customer.count }.by(1)
      end

      it "plus 1 for pending_processing_task_count_today" do
        expect do
          auth_post :create, intention: seek_params
          Intention.find_by(customer_name: seek_params[:customer_name])
                   .update(processing_time: Time.zone.now, state: "processing")
        end.to change {
          TaskStatistic::Service.new([zhangsan])
                                .send(:pending_processing_task_count_today)
        }.by(1)
      end

      it "returns invalid when duplicated request" do
        my_seek_params = { "intention" =>
                            {
                              "intention_type" => "seek",
                              "state" => "untreated",
                              "customer_name" => "15157126128",
                              "customer_phone" => "15157126128",
                              "province" => "澳门特别行政区",
                              "city" => "澳门特别行政区",
                              "seeking_cars" =>
                                [
                                  {
                                    "brand_name" => "北汽绅宝",
                                    "series_name" => "绅宝D80"
                                  }
                                ]
                            }
                         }

        expect do
          auth_post :create, my_seek_params
        end.to change { Customer.count }.by(1)

        auth_post :create, my_seek_params

        expect(response.status).to eq 403
      end
    end

    context "create sale intention" do
      it "creates a record" do
        expect do
          auth_post :create, intention: sale_params
        end.to change { tianche.intentions.count }.by(1)
      end

      it "creates customer" do
        expect do
          auth_post :create, intention: sale_params
        end.to change { Customer.count }.by(1)
      end

      it "sets consigned_at" do
        auth_post :create, intention: sale_params

        expect(Intention.last.consigned_at).to eq Date.new(2015, 1, 12)
      end
    end
  end

  describe "PUT /api/v1/intentions/:id" do
    it "updates a record" do
      jack_reservation.customer_id = doraemon.id
      jack_reservation.save

      seeking_cars = [
        {
          "brand_name" => "奥迪",
          "series_name" => "A6"
        }
      ]

      params = seek_params.merge(
        customer_phones: [],
        customer_name: "abc",
        seeking_cars: seeking_cars,
        channel_id: aodi_5s.id,
        state: "reserved"
      )

      expect(doraemon_seeking_aodi.customer_phones).to be_present
      auth_post :update, id: doraemon_seeking_aodi.id, intention: params

      doraemon_seeking_aodi.reload
      expect(doraemon_seeking_aodi.customer_name).to eq "abc"
      expect(doraemon_seeking_aodi.customer_phones).to be_empty
      expect(doraemon_seeking_aodi.read_attribute(:seeking_cars)).to eq seeking_cars
      expect(jack_reservation.reload.customer_channel_id).to eq aodi_5s.id
    end

    it "更新服务归属人" do
      params = seek_params.merge(
        after_sale_assignee_id: doraemon_seeking_aodi.assignee_id
      )

      auth_post :update, id: doraemon_seeking_aodi.id, intention: params
      expect(doraemon_seeking_aodi.reload.after_sale_assignee).to eq doraemon_seeking_aodi.assignee
    end

    it "changes earnest status" do
      params = seek_params.merge(earnest: true)
      auth_put :update, id: doraemon_seeking_aodi.id, intention: params
      expect(response_json[:data][:earnest]).to be_truthy
    end

    it "send jpush to user if assignee_id changed" do
      give_authority(zhangsan, "全部客户管理")
      params = seek_params.merge(assignee_id: lisi.id)
      expect(IntentionMessageWorker).to receive(:perform_in)

      auth_put :update, id: doraemon_seeking_aodi.id, intention: params
      operation_record = doraemon_seeking_aodi.operation_records.last

      expect(
        operation_record.intention_message_text
      ).to eq "#{zhangsan.name}分配客户#{doraemon.name}给你, 请及时跟进"
    end

    context "所属公司是联盟管理公司" do
      before do
        give_authority(zhangsan, "全部客户管理")
        tianche.update!(alliance_manager: alliance_tianche)
        doraemon_seeking_aodi.update!(company_id: tianche.id,
                                      assignee_id: nil,
                                      alliance_company_id: nil)
      end

      it "更改归属人时，设置alliance_company_id值" do
        params = seek_params.merge(assignee_id: lisi.id)
        auth_put :update, id: doraemon_seeking_aodi.id, intention: params

        expect(doraemon_seeking_aodi.reload.alliance_company_id).to eq alliance_tianche.id
        expect(doraemon_seeking_aodi.reload.assignee_id).to eq lisi.id
      end

      it "如果这条意向已被分配给某个具体联盟车商，不需要再做处理" do
        tianche.update!(alliance_manager: nil)
        doraemon_seeking_aodi.update!(company_id: tianche.id,
                                      alliance_company_id: alliance_tianche.id)

        params = seek_params.merge(assignee_id: lisi.id)
        auth_put :update, id: doraemon_seeking_aodi.id, intention: params

        expect(doraemon_seeking_aodi.reload.alliance_company_id).to eq alliance_tianche.id
        expect(doraemon_seeking_aodi.reload.assignee_id).to eq lisi.id
      end
    end

    context "修改到期提醒日期" do
      before do
        ExpirationSetting.init(tianche)
        give_authority(zhangsan, "全部客户管理")
        travel_to Time.zone.parse("2017-2-23")
      end

      it "可以修改提醒日期" do
        params = seek_params.merge(
          annual_inspection_notify_date: "2017-2-25",
          insurance_notify_date: "2017-5-25",
          mortgage_notify_date: "2017-7-23"
        )

        auth_put :update, id: doraemon_seeking_aodi, intention: params

        doraemon_seeking_aodi.reload
        date = doraemon_seeking_aodi.annual_inspection_notify_date
        expect(date).to eq Time.zone.parse("2017-2-25").to_date
      end

      it "生成相应的 ExpirationNotification" do
        insurance_notify = ExpirationNotification.create!(
          associated: doraemon_seeking_aodi,
          notify_type: :insurance,
          notify_name: :insurance,
          setting_date: Time.zone.parse("2017-3-8"),
          notify_date: Time.zone.parse("2017-3-5"),
          company_id: tianche.id,
          user_id: zhangsan.id
        )

        params = seek_params.merge(
          annual_inspection_notify_date: "2017-2-25",
          insurance_notify_date: "2017-5-25",
          mortgage_notify_date: "2017-7-23"
        )

        expect do
          auth_put :update, id: doraemon_seeking_aodi, intention: params
        end.to change { ExpirationNotification.count }.by 2

        insurance_notify.reload
        expect(insurance_notify.setting_date).to eq Time.zone.parse("2017-5-25").to_date
        expect(insurance_notify.notify_date).to eq Time.zone.parse("2017-4-25").to_date
      end
    end
  end

  describe "POST /api/v1/intentions/check" do
    it "意向可否创建检测, 已完成意向可以创建" do
      auth_get :check, phone: "114"

      expect(response.status).to eq 200
    end

    it "意向可否创建检测, 已有客户且无未完成意向可以创建" do
      auth_get :check, customer_id: gian.id

      expect(response.status).to eq 200
    end

    it "意向可否创建检测, 客户不存在可以创建" do
      auth_get :check, phone: "123456789"

      expect(response.status).to eq 200
    end

    it "意向可否创建检测, 自己已有意向不能创建" do
      auth_get :check, phone: "110"

      expect(response.status).to eq 403
    end

    it "意向可否创建检测, 其他员工已跟进客户不能创建" do
      auth_get :check, phone: "115"

      expect(response.status).to eq 403
    end
  end

  describe "GET /api/v1/intentions" do
    it "list all intentions" do
      auth_get :index

      expect(response_json[:data].size).to be > 0
      expect(response_json[:meta]).to be_present

      assignee_ids = response_json[:data].map do |intention|
        intention[:assignee][:id]
      end.uniq
      expect(assignee_ids).to include(lisi.id)
      expect(response_json[:meta][:assignees]).to be_present
    end

    it "lists intentions by task" do
      TaskStatistic.increment(
        :intention_interviewed, zhangsan, doraemon_seeking_aodi.id
      )

      auth_get :index,
               user_ids: zhangsan.id, # 用户id以逗号隔开拼成字符串
               task_statistic_type: "intention_interviewed"

      expect(response_json[:data]).to be_present
    end

    it "lists intentions by daily_management" do
      auth_get :index,
               daily_management_user: "sale_manager",
               daily_management_type: "finished_intentions"
      expect(response_json[:data]).to be_present
    end

    it "list all recyle intentions by daily_management" do
      auth_get :index,
               daily_management_user: "sale_user",
               daily_management_type: "waiting_recycle_intentions"

      expect(response_json[:data]).to be_present
    end

    it "lists pending intentions by daily_management" do
      auth_get :index,
               daily_management_user: "sale_manager",
               daily_management_type: "pending_intentions"
      expect(response_json[:data]).to be_present
    end

    it "lists expired dealing intentions by daily_management" do
      auth_get :index,
               daily_management_user: "sale_user",
               daily_management_type: "expired_dealing_intentions"
      expect(response_json[:data].size).to eq 0
    end

    it "列出所有意向，包括共享的意向" do
      doraemon_seeking_aodi.update(assignee_id: lisi.id)

      lisi.update(manager_id: nil)
      IntentionSharedUser.create(
        intention_id: doraemon_seeking_aodi.id,
        user_id: zhangsan.id
      )

      auth_get :index
      ids = response_json[:data].map { |data| data.fetch(:id) }
      expect(ids).to include doraemon_seeking_aodi.id
    end
  end

  describe "GET /api/v1/intentions/recycle" do
    it "列出所有可回收意向" do
      give_authority(zhangsan, "求购客户跟进")
      auth_get :to_be_recycled
      expect(response_json[:data].size).to be > 0
    end

    it "不应该列出正在处理的意向" do
      give_authority(zhangsan, "求购客户跟进")
      auth_get :to_be_recycled, query: { state_eq: "processing" }

      expect(response_json[:data]).to be_empty
    end

    it "没有权限, 则返回空" do
      auth_get :to_be_recycled
      expect(response_json[:data]).to be_empty
    end

    it "公司未设置过期时间, 则返回空" do
      login_user(git)
      give_authority(git, "全部客户管理")
      auth_get :to_be_recycled
      expect(response_json[:data]).to be_empty
    end
  end

  describe "PUT /api/v1/intentions/recycle" do
    it "更改意向归属人" do
      give_authority(zhangsan, "求购客户跟进")
      auth_put :recycle, intention_ids: [gian_seeking_aodi.id] # used to be lisi
      expect(response_json[:data]).to include gian_seeking_aodi.id
    end

    it "领取后, 清除之前的共享关系" do
      # 张三分享给李四、王五
      give_authority(zhangsan, "求购客户跟进")
      [lisi, wangwu].each do |user|
        IntentionSharedUser.create(
          user_id: user.id,
          intention_id: cruise_seeking_bmw.id
        )
      end
      expect(wangwu.shared_intentions).to include cruise_seeking_bmw

      # 李四领取
      login_user(lisi)
      give_authority(lisi, "求购客户跟进")

      auth_put :recycle, intention_ids: [cruise_seeking_bmw.id]
      expect(response_json[:data]).to include cruise_seeking_bmw.id
      expect(wangwu.shared_intentions).to be_empty
    end

    it "不能跨越权限, 收购人员不能认领出售意向" do
      give_authority(zhangsan, "求购客户跟进")
      auth_put :recycle, intention_ids: [cruise_sell_aodi.id]
      expect(response_json[:data]).to be_empty
    end
  end

  shared_examples "keyword search" do
    describe "意向列表关键词搜索" do
      it "根据客户名称，意向描述，客户电话搜索" do
        auth_get :index, query: { keyword: keyword }

        expect(response_json[:data].size).to be > 0
      end
    end
  end

  describe "GET /api/v1/intentions/" do
    it "根据客户名称，号码，意向描述搜索失败" do
      auth_get :index, query: { keyword: "ert" }

      expect(response_json[:data].size).to eq 0
    end

    it_behaves_like "keyword search" do
      let(:keyword) { doraemon_seeking_aodi.customer_name }
    end

    it_behaves_like "keyword search" do
      let(:keyword) { doraemon_seeking_aodi.customer_phones.first }
    end

    it_behaves_like "keyword search" do
      let(:keyword) { doraemon_seeking_aodi.intention_note }
    end

    it_behaves_like "keyword search" do
      let(:keyword) { doraemon_seeking_aodi.seeking_cars.first[:brand_name] }
    end
  end

  describe "GET /api/v1/intentions/:id" do
    it "describes this intention" do
      auth_get :show, id: doraemon_seeking_aodi.id
      expect(response_json[:data]).to be_present
    end

    it "包含是否已收意向金" do
      auth_get :show, id: doraemon_seeking_aodi.id

      expect(response_json[:data][:earnest]).to be_falsy
    end

    it "返回提醒到期日期" do
      travel_to Time.zone.parse("2017-2-24")
      ExpirationSetting.init(tianche)

      memory_dates = [
        { name: "生日", date: "2-1", notification_id: cruise_birth_date.id },
        { name: "爱人生日", date: "3-6" },
        { name: "asdf", date: "4-7" }
      ]

      doraemon_seeking_aodi.customer.update!(
        memory_dates: memory_dates
      )

      doraemon_seeking_aodi.update!(
        annual_inspection_notify_date: "2017-2-25",
        insurance_notify_date: "2017-1-2",
        mortgage_notify_date: "2017-7-23"
      )

      auth_get :show, id: doraemon_seeking_aodi.id
      expect(response_json[:data]).to be_present
    end

    context "意向已成交" do
      it "返回显示成交车辆信息及付款类型" do
        doraemon_seeking_aodi.update!(
          state: :completed,
          closing_car_id: aodi.id,
          after_sale_assignee: zhangsan
        )

        stock_out_inventory = aodi.find_or_create_stock_out_inventory
        stock_out_inventory.update!(payment_type: :mortgage)

        auth_get :show, id: doraemon_seeking_aodi.id

        expect(response_json[:data].keys).to include :finished_payment_type
        expect(response_json[:data][:after_sale_assignee]).to be_present
      end
    end
  end

  describe "GET /api/v1/intentions/:id/cars" do
    it "匹配在库车辆" do
      doraemon_seeking_aodi.update_column(:minimum_price_cents, nil)
      doraemon_seeking_aodi.update_column(:maximum_price_cents, nil)

      auth_get :cars, id: doraemon_seeking_aodi.id, need_companies: true

      expect(response_json[:data].size).to be > 0
      expect(response_json[:meta][:companies].size).to be > 0
    end
  end

  describe "GET /api/v1/intentions/:id/alied_cars" do
    it "匹配联盟车辆" do
      doraemon_seeking_aodi.update_column(:minimum_price_cents, nil)
      doraemon_seeking_aodi.update_column(:maximum_price_cents, nil)

      auth_get :alied_cars, id: doraemon_seeking_aodi.id, need_companies: true

      expect(response.status).to eq 200
    end

    it "匹配联盟车辆, 根据联盟公司查询" do
      doraemon_seeking_aodi.update_column(:minimum_price_cents, nil)
      doraemon_seeking_aodi.update_column(:maximum_price_cents, nil)

      auth_get :alied_cars, id: doraemon_seeking_aodi.id, query: {
        allied_companies_id_eq: tianche.id
      }

      expect(response.status).to eq 200
    end

    it "匹配联盟车辆, 根据联盟名称查询" do
      doraemon_seeking_aodi.update_column(:minimum_price_cents, nil)
      doraemon_seeking_aodi.update_column(:maximum_price_cents, nil)

      auth_get :alied_cars, id: doraemon_seeking_aodi.id, query: {
        alliances_name_cont: "复仇者联盟"
      }

      expect(response.status).to eq 200
    end
  end

  describe "PUT /api/v1/intentions/batch_assign" do
    it "reassigns intentions" do
      auth_put :batch_assign, intention_ids: [doraemon_seeking_aodi.id], assignee_id: lisi.id

      expect(doraemon_seeking_aodi.reload.assignee_id).to eq lisi.id
    end
  end

  describe "POST /api/v1/intentions/import" do
    it "upload a file" do
      allow(DacWorker).to receive(:perform_async).and_return("a")
      allow(SecureRandom).to receive(:hex).and_return("a")

      expect(ImportIntentionsWorker).to receive(:perform_async)

      auth_post :import, file: import_intentions
    end

    it "will be blocked if the file is invalid" do
      allow(DacWorker).to receive(:perform_async).and_return("a")
      expect(ImportIntentionsWorker).not_to receive(:perform_async)

      auth_post :import, file: import_intentions_invalid
      expect(response.status).to eq 422
    end
  end

  describe "DELETE /api/v1/intentions/batch_destroy" do
    it "全部客户管理 批量删除意向" do
      give_authority(zhangsan, "全部客户管理")

      auth_delete :batch_destroy, intention_ids: [doraemon_seeking_aodi.id]

      expect(doraemon_seeking_aodi.reload.deleted_at).to be_present
    end

    it "批量删除意向" do
      give_authority(zhangsan, "全部求购客户管理", "全部出售客户管理")

      auth_delete :batch_destroy, intention_ids: [doraemon_seeking_aodi.id]

      expect(doraemon_seeking_aodi.reload.deleted_at).to be_present
    end
  end

  describe "PUT share" do
    context "这个意向的归属人是本身" do
      it "可以把这个意向共享给同shop的其他人" do
        doraemon_seeking_aodi.update(assignee: zhangsan)
        auth_put :share, id: doraemon_seeking_aodi, shared_users: [lisi]

        expect(lisi.shared_intentions).to include doraemon_seeking_aodi
      end
    end

    context "这个意向的归属人不是自己" do
      it "不能分享这个意向" do
        doraemon_seeking_aodi.update(assignee: lisi)
        auth_put :share, id: doraemon_seeking_aodi, shared_users: [zhangsan]

        expect(response.status).to eq 403
      end
    end
  end

  describe "GET chat_detail" do
    it "得到分享到聊天里的意向详情" do
      doraemon_seeking_aodi.update(assignee: lisi)
      auth_get :chat_detail, id: doraemon_seeking_aodi
      expect(response_json[:data][:id]).to eq doraemon_seeking_aodi.id
    end
  end

  describe "PUT send_chat" do
    it "如果这个意向没有归属人，设置为当前用户" do
      doraemon_seeking_aodi.update(assignee: nil)
      auth_get :send_chat, id: doraemon_seeking_aodi
      expect(doraemon_seeking_aodi.reload.assignee).to eq zhangsan
    end
  end
end
