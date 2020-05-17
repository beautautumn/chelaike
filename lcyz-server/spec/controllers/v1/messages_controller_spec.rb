require "rails_helper"

RSpec.describe V1::MessagesController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:aodi_created_message) { messages(:aodi_created_message) }
  let(:aodi_created_record) { operation_records(:aodi_created_record) }

  let(:alliance_invitation) { operation_records(:alliance_invitation_record) }
  let(:daily_report) { operation_records(:tianche_daily_report) }
  let(:alliance_create_car) { operation_records(:alliance_aodi_created_record) }

  before do
    login_user(zhangsan)
  end

  describe "GET /messages" do
    it "returns messages list" do
      auth_get :index

      result = {
        id: aodi_created_record.id,
        operation_record_type: "car_created",
        user_id: zhangsan.id,
        name: zhangsan.name,
        created_at: iso8601_format("2015-01-10"),
        company_id: zhangsan.company_id,
        operation_record_type_color: "#7fbb5b",
        detail_text: "新车入库",
        messages: {
          name: aodi.name,
          title: "新车入库",
          imported: false,
          user_name: zhangsan.name,
          stock_number: "abc",
          acquirer_name: zhangsan.name
        }
      }

      expect(response_json[:data].last).to eq result
      expect(aodi_created_message.reload.read).to be_truthy
    end

    it "supports search" do
      auth_get :index, query: {
        operation_record_operation_record_type_eq: "stock_out"
      }, stock_out_type: "sold"

      expect(response_json[:data].size).to eq 1
    end

    it "按时间范围搜索" do
      auth_get :index, query: {
        created_at_gteq: "2015-01-10",
        created_at_lteq: "2015-01-10"
      }

      expect(response_json[:data].size).to eq 3
    end
  end

  describe "GET /messages/:id" do
    it "获取单条消息" do
      auth_get :show, id: aodi_created_record.id

      expect(response_json[:data][:id]).to eq aodi_created_record.id
    end
  end

  describe "GET /messages/unread" do
    it "returns size of unread messages" do
      auth_get :unread

      result = {
        data: {
          unread_count: 2
        }
      }

      expect(response_json).to eq result
    end
  end

  describe "GET #categoried_index" do
    it "根据消息类型得到相应的消息列表" do
      auth_get :categoried_index, category: :stock
      expect(response_json).to be_present
    end

    context "有搜索过滤" do
      it "得到过滤后的结果" do
        # company = zhangsan.company
        # company.unified_management = false
        # company.save!

        # zhangsan.operation_records.update_all(shop_id: zhangsan.shop_id)

        auth_get :categoried_index, category: :stock,
                                    query: { operation_record_type_eq: "stock_out" }
        expect(response_json).to be_present
      end
    end
  end

  describe "车辆定价消息权限" do
    it "获取定价消息" do
      auth_get :categoried_index, category: :stock
      priced_message = response_json[:data].find { |m| m[:operation_record_type] == "car_priced" }
      expect(priced_message).to be_present
    end

    it "没有权限, 能收到消息但看不到价格" do
      deprive_authority(zhangsan, %w(销售底价查看 经理底价查看))
      auth_get :categoried_index, category: :stock
      priced_message = response_json[:data].find { |m| m[:operation_record_type] == "car_priced" }
      expect(priced_message).to be_present
      expect(priced_message[:messages][:manager_price_wan]).to be_blank
    end
  end
end
