require "rails_helper"

RSpec.describe Dw::Analysis::ClosingCost do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:analysis) { Dw::Analysis::ClosingCost.new(tianche.id) }
  let(:stock_out_at_conditions) { analysis.stock_out_at_conditions(Time.zone.now, "day") }

  describe "out of stock info" do
    before do
      travel_to Time.zone.parse("2015-01-20")
    end

    it "shows info by closing cost" do
      result = analysis.out_of_stock_info(stock_out_at_conditions)

      expected_result = {
        average_out_stock_amount: 30.0,
        gross_profit: 0.0,
        gross_profit_rate: "0.0%",
        price_range: "30-50万",
        out_stock_count: 1,
        cars_count_proportion: "100.0%",
        out_stock_amount_proportion: "100.0%",
        out_stock_amount: 30.0
      }
      expect(result.first).to eq expected_result
    end
  end
end
