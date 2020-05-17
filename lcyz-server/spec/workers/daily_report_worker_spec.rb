require "rails_helper"

RSpec.describe DailyReportWorker do
  fixtures :all

  let(:tianche) { companies(:tianche) }

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

  it "create messages" do
    VCR.use_cassette("rongcloud/system_message") do
      expect do
        DailyReportWorker.new.perform(tianche.id)
      end.to change { OperationRecord.count }.by(1)
    end
  end
end
