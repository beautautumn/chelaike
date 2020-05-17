require "rails_helper"

RSpec.describe MessageWorker do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:lisi) { users(:lisi) }
  let(:wangwu) { users(:wangwu) }
  let(:aodi_created) { operation_records(:aodi_created_record) }
  let(:aodi_sold) { operation_records(:aodi_1_stock_out_sold_record) }
  let(:aodi_stock_warning) { operation_records(:aodi_stock_warning_record) }
  let(:token_recharged) { operation_records(:token_recharged) }

  before do
    User.create!(id: -100, username: "statistics_messager", name: "统计消息",
                 phone: "statistics_messager", password: "e5f732bea0edc282fd9d")
    User.create!(id: -200, username: "stock_messager", name: "库存消息",
                 phone: "stock_messager", password: "463af81dca326aff30fb")
    User.create!(id: -300, username: "customer_messager", name: "客户消息",
                 phone: "customer_messager", password: "77e304e80b2078e488c7")
    User.create!(id: -400, username: "system_messager", name: "系统消息",
                 phone: "system_messager", password: "fa494f72fd883fb9c9cf")
  end

  # describe "#send_jpush" do
  #   it "发送jpush" do
  #     MessageWorker.new.send_jpush(create_aodi, [1, 2])
  #   end
  # end

  describe "#send_rong_push" do
    it "发送rongcloud消息" do
      VCR.use_cassette("rongcould/user", record: :new_episodes) do
        MessageWorker.new.send_rong_push(aodi_sold, [1, 2])
      end
    end
  end

  describe "#select_users" do
    it "库存消息发给评估师和具有“车辆销售定价”、“收购价格查看”权限的人" do
      give_authority(lisi, "车辆销售定价")
      give_authority(wangwu, "收购价格查看")
      VCR.use_cassette("rongcould/user", record: :new_episodes) do
        expect do
          MessageWorker.new.perform(aodi_stock_warning.id)
        end.to change { Message.count }.by 3
      end
    end
    it "新车入库时匹配意向, 只提醒匹配到客户归属销售跟进的员工" do
      VCR.use_cassette("rongcould/user", record: :new_episodes) do
        expect do
          MessageWorker.new.perform(aodi_created.id)
        end.to change { Message.count }.by 4

        # TODO: 只有匹配意向的归属人收到匹配意向消息，其他人只收到普通车辆入库
      end
    end
  end

  describe "solo message" do
    it "单发" do
      VCR.use_cassette("rongcould/user", record: :new_episodes) do
        expect do
          MessageWorker.new.perform(token_recharged.id, true)
        end.to change { Message.count }.by 1
      end
    end
  end
end
