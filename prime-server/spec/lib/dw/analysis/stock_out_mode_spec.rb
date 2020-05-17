require "rails_helper"

RSpec.describe Dw::Analysis::StockOutMode do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:analysis) { Dw::Analysis::StockOutMode.new(tianche.id) }
  let(:stock_out_at_conditions) { analysis.stock_out_at_conditions(Time.zone.now, "day") }

  describe "out of stock info" do
    before do
      travel_to Time.zone.parse("2015-01-20")
    end

    it "shows info by stock out inventory type" do
      result = analysis.out_of_stock_info(stock_out_at_conditions)

      expected_result = {
        modes: ["retail_cash"],
        cars_total_count: 1,
        total_out_stock_amount: 30.0,
        detail: {
          "retail_cash" => {
            out_stock_count: 1,
            out_stock_amount: 30.0,
            cars_count_proportion: "100.0%",
            out_stock_amount_proportion: "100.0%"
          }
        }
      }
      expect(result).to eq expected_result
    end
  end
end
