require "rails_helper"

RSpec.describe V1::IntentionPushHistoriesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:aodi) { cars(:aodi) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:cruise_sell_aodi) { intentions(:cruise_sell_aodi) }
  let(:intention_level_b) { intention_levels(:intention_level_b) }

  before do
    login_user(zhangsan)
    travel_to Time.zone.parse("2015-10-01")
  end

  describe "GET /api/v1/intentions/:intention_id/intention_push_histories" do
    it "lists all intention_push_histories" do
      auth_get :index, intention_id: doraemon_seeking_aodi.id

      expect(response_json).to be_present
    end
  end

  describe "POST /api/v1/intentions/:intention_id/intention_push_histories" do
    def intention_processing_action
      auth_post :create, intention_id: doraemon_seeking_aodi.id,
                         intention_push_history: {
                           state: "processing",
                           processing_time: Time.zone.now + 1.day,
                           checked: true,
                           intention_level_id: intention_level_b.id
                         }
    end

    context "task statistic" do
      it "plus 1 for intention_processed_count_today" do
        expect do
          intention_processing_action
        end.to change {
          TaskStatistic.find_by(
            user_id: zhangsan.id, record_date: Time.zone.today
          ).intention_interviewed.size
        }.by(1)
      end

      it "plus 1 for pending_processing_finished_count_today" do
        expect do
          doraemon_seeking_aodi.update_columns(processing_time: Time.zone.now.midnight)

          intention_processing_action
        end.to change {
          TaskStatistic.find_by(
            user_id: zhangsan.id, record_date: Time.zone.today
          ).pending_processing_finished
        }
      end
    end

    context "seek intention" do
      before do
        @request_lambda = lambda do
          auth_post :create, intention_id: doraemon_seeking_aodi.id,
                             intention_push_history: {
                               state: "processing",
                               processing_time: Time.zone.parse("2015-01-12"),
                               checked: true,
                               intention_level_id: intention_level_b.id,
                               car_ids: [aodi.id],
                               note: "abc"
                             }
        end
      end

      it "creates a history" do
        expect { @request_lambda.call }.to change { IntentionPushHistory.count }.by(1)
      end

      it "updates intention" do
        @request_lambda.call

        doraemon_seeking_aodi.reload
        push_history = doraemon_seeking_aodi.intention_push_histories.last

        expect(doraemon_seeking_aodi.intention_level_id).to eq intention_level_b.id
        expect(doraemon_seeking_aodi.processing_time).to eq Date.new(2015, 1, 12)
        expect(doraemon_seeking_aodi.interviewed_time).to eq nil
        expect(push_history.checked_count).to eq 1
        expect(doraemon_seeking_aodi.checked_count).to eq 1
        expect(doraemon_seeking_aodi.in_shop_at).to be_present
      end

      it "updates assignee_id if assignee_id is blank" do
        give_authority(zhangsan, "全部客户管理")
        doraemon_seeking_aodi.update_columns(assignee_id: nil)

        expect { @request_lambda.call }.to change {
          doraemon_seeking_aodi.reload.assignee_id
        }.from(nil).to(zhangsan.id)
      end

      it "records cars viewed" do
        expect { @request_lambda.call }
          .to change { doraemon_seeking_aodi.cars.count }.by(1)
      end

      it "syncs prices to stock_out_inventory" do
        aodi.stock_out_inventories.update_all(current: false)

        auth_post :create, intention_id: doraemon_seeking_aodi.id,
                           intention_push_history: {
                             state: "completed",
                             processing_time: Time.zone.parse("2015-01-12"),
                             checked: true,
                             intention_level_id: intention_level_b.id,
                             closing_car_id: aodi.id,
                             deposit_wan: 5,
                             closing_cost_wan: 30,
                             closing_car_name: "abc"
                           }

        expect(doraemon_seeking_aodi.reload.closing_car_id).to eq aodi.id
        expect(doraemon_seeking_aodi.closing_car_name).to eq "abc"
        expect(aodi.stock_out_inventory.deposit_wan).to eq 5
        expect(aodi.stock_out_inventory.closing_cost_wan).to eq 30
      end

      it "如果完成意向，同时设置服务归属人" do
        auth_post :create, intention_id: doraemon_seeking_aodi.id,
                           intention_push_history: {
                             state: "completed",
                             processing_time: Time.zone.parse("2015-01-12"),
                             checked: true,
                             intention_level_id: intention_level_b.id,
                             closing_car_id: aodi.id,
                             deposit_wan: 5,
                             closing_cost_wan: 30,
                             closing_car_name: "abc"
                           }
        expect(doraemon_seeking_aodi.reload.after_sale_assignee_id).to eq zhangsan.id
      end

      context "分享给自己的意向" do
        before do
          doraemon_seeking_aodi.update(assignee_id: lisi.id)
          lisi.update(manager_id: nil)
          IntentionSharedUser.create(
            user_id: zhangsan.id,
            intention_id: doraemon_seeking_aodi.id
          )
        end

        it "也可以创建跟进历史" do
          auth_post :create, intention_id: doraemon_seeking_aodi.id,
                             intention_push_history: {
                               state: "completed",
                               processing_time: Time.zone.parse("2015-01-12"),
                               checked: true,
                               intention_level_id: intention_level_b.id,
                               closing_car_id: aodi.id,
                               deposit_wan: 5,
                               closing_cost_wan: 30,
                               closing_car_name: "abc"
                             }

          expect(doraemon_seeking_aodi.reload.assignee_id).to eq lisi.id
          expect(doraemon_seeking_aodi.latest_intention_push_history.executor_id).to eq zhangsan.id
        end
      end
    end

    context "sale intention" do
      before do
        @request_lambda = lambda do
          auth_post :create, intention_id: cruise_sell_aodi.id,
                             intention_push_history: {
                               state: "processing",
                               interviewed_time: Time.zone.parse("2015-01-12"),
                               checked: true, # 是否评估实车
                               estimated_price_wan: 12,
                               note: "abc"
                             }
        end
      end

      it "creates a history" do
        expect { @request_lambda.call }.to change { IntentionPushHistory.count }.by(1)
      end

      it "updates assignee_id if assignee_id is blank" do
        give_authority(zhangsan, "全部客户管理")
        cruise_sell_aodi.update_columns(assignee_id: nil)

        expect { @request_lambda.call }.to change {
          cruise_sell_aodi.reload.assignee_id
        }.from(nil).to(zhangsan.id)
      end

      it "updates assignee_id if assignee_id is blank" do
        give_authority(zhangsan, "全部出售客户管理")
        cruise_sell_aodi.update_columns(assignee_id: nil)

        expect { @request_lambda.call }.to change {
          cruise_sell_aodi.reload.assignee_id
        }.from(nil).to(zhangsan.id)
      end

      it "set estimated_price" do
        @request_lambda.call

        history = cruise_sell_aodi.intention_push_histories.last

        expect(cruise_sell_aodi.reload.estimated_price_wan).to eq 12
        expect(history.estimated_price_wan).to eq 12
      end
    end
  end
end
