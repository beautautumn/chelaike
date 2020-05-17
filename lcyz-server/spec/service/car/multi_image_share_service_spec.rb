require "rails_helper"

RSpec.describe Car::MultiImageShareService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:service) { Car::RelativeStatisticService.new(zhangsan, aodi) }

  describe "#execute" do
    it "生成相应字段" do
      allow_any_instance_of(Car::WeshopService)
        .to receive(:shared_detail_url).and_return("http://weshop_url")
      allow_any_instance_of(Util::AliyunOssNew)
        .to receive(:upload).and_return("http://aliyun-oss")

      service = Car::MultiImageShareService.new(zhangsan, aodi)
      result = service.execute

      expect(result).to be_present
    end
  end
end
