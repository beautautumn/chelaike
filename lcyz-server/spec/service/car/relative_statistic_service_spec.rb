require "rails_helper"

RSpec.describe Car::RelativeStatisticService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:service) { Car::RelativeStatisticService.new(zhangsan, aodi) }

  describe "#execute" do
    it "returns infomations for car" do
      expect(service.execute).to eq(
        intentions_count: 1,
        checked_intentions_count: 1,
        similar_in_stock_count: 2,
        similar_sold_count: 0
      )
    end
  end
end
