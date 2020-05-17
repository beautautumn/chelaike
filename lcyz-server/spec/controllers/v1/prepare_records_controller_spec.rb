require "rails_helper"

RSpec.describe V1::PrepareRecordsController do
  fixtures :all

  let(:aodi) { cars(:aodi) }
  let(:baomihua) { prepare_items(:baomihua_item) }
  let(:ticket) { prepare_items(:ticket_item) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)

    give_authority(zhangsan, "整备信息录入", "整备信息查看", "整备费用查看")
  end

  describe "GET /api/v1/cars/prepare_records" do
    it "获取整备管理列表" do
      auth_get :index

      expect(response_json[:data].size).to be > 0
    end
  end

  describe "GET /api/v1/cars/:car_id/prepare_record/" do
    it "获取车辆的整备信息" do
      auth_get :show, car_id: aodi.id

      expect(response_json[:data]
        .slice(:state, :total_amount_yuan, :car_id, :repair_state))
        .to eq(
          state: "preparing",
          total_amount_yuan: 100,
          car_id: aodi.id,
          repair_state: "first_time"
        )
    end
  end

  describe "PUT /api/v1/cars/:car_id/prepare_record/" do
    it "编辑整备信息 - 基本信息" do
      prepare_record = {
        state: "progress",
        repair_state: "second_time",
        total_amount_yuan: 2_000,
        note: "整备信息",
        start_at: "2016-08-08",
        end_at: "2016-08-10"
      }
      auth_put :update, car_id: aodi.id, prepare_record: prepare_record

      expect(
        response_json[:data].slice(
          :state, :repair_state, :total_amount_yuan, :note, :start_at, :end_at
        )
      ).to eq prepare_record
    end

    it "创建日志数据" do
      expect { auth_put :update, car_id: aodi.id, prepare_record: { repair_state: "second_time" } }
        .to change { OperationRecord.where(operation_record_type: :prepare_record_updated).count }
    end

    it "编辑整备信息 - 整备项目" do
      prepare_record = {
        prepare_items_attributes: [
          {
            name: "看电影",
            total_amount_yuan: 100,
            note: "色戒"
          },
          {
            id: baomihua.id,
            name: "爆大米花"
          },
          {
            id: ticket.id,
            _destroy: 1
          }
        ]
      }

      auth_put :update, car_id: aodi.id, prepare_record: prepare_record

      prepare_items = response_json[:data][:prepare_items]
      expect(prepare_items.size).to eq 2
      expect(prepare_items.map { |item| item[:name] }.sort!)
        .to eq %w(看电影 爆大米花).sort!
    end
  end
end
