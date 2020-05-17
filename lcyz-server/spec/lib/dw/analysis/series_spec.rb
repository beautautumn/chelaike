require "rails_helper"

RSpec.describe Dw::Analysis::Series do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:analysis) { Dw::Analysis::Series.new(tianche.id) }
  let(:acquired_at_conditions) { analysis.acquired_at_conditions(Time.zone.now, "day") }
  let(:car_ids_conditions) { { car_id_in: analysis.stock_by_month_car_ids(Time.zone.now) } }

  describe "stock_info" do
    before do
      travel_to Time.zone.parse("2015-01-01")
    end

    context "acquisition info by series" do
      it "shows acquired info" do
        result = analysis.stock_info(acquired_at_conditions)

        expected_result = {
          series_name: "奥迪A3",
          acquisition_amount: 20.0,
          average_acquisition_amount: 20.0,
          acquisition_count: 1,
          cars_count_proportion: "100.0%",
          acquisition_amount_proportion: "100.0%"
        }

        expect(result.first).to eq expected_result
      end
    end

    context "stock info by series" do
      it "shows stock info" do
        result = analysis.stock_info(car_ids_conditions)

        expected_result = {
          acquisition_amount: 35.0,
          series_name: "奥迪A3",
          acquisition_count: 2,
          average_acquisition_amount: 17.5,
          cars_count_proportion: "100.0%",
          acquisition_amount_proportion: "100.0%"
        }

        expect(result.first).to eq expected_result
      end
    end
  end

  describe "out_of_stock_info" do
    before do
      travel_to Time.zone.parse("2015-01-20")
    end

    it "shows out of stock info" do
      result = analysis.out_of_stock_info(acquired_at_conditions)

      expected_result = {
        series_name: "奥迪A3",
        out_stock_count: 1,
        average_out_stock_amount: 30.0,
        gross_profit: 0.0,
        gross_profit_rate: "0.0%",
        cars_count_proportion: "100.0%",
        out_stock_amount_proportion: "100.0%",
        out_stock_amount: 30.0
      }

      expect(result.first).to eq expected_result
    end
  end
end
