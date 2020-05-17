require "rails_helper"

RSpec.describe Car::CreateService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:service) { Car::RelativeStatisticService.new(zhangsan, aodi) }

  describe "#acquisition_create" do
    it "创建一个入库车辆"

    it "创建一个入库过户信息"

    it "创建整备记录"

    it "创建操作记录"
  end
end
