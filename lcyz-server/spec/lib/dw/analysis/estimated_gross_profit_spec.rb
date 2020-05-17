require "rails_helper"

RSpec.describe Dw::Analysis::EstimatedGrossProfit do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:analysis) { Dw::Analysis::EstimatedGrossProfit.new(tianche.id) }
  let(:car_ids_conditions) { { car_id_in: analysis.current_in_stock_car_ids } }

  describe "#stock_info" do
    before do
      travel_to Time.zone.parse("2015-01-01")
    end

    it "shows info by estimated gross profit" do
      result = analysis.stock_info(car_ids_conditions)

      expected_result = {
        acquisition_count: 2,
        acquisition_amount: 35.0,
        cars_count_proportion: "100.0%",
        acquisition_amount_proportion: "100.0%",
        estimated_gross_profit: "1-5万",
        average_estimated_gross_profit: 3.0,
        average_estimated_gross_profit_rate: "2.0%"
      }

      expect(result.first).to eq expected_result
    end
  end
end
