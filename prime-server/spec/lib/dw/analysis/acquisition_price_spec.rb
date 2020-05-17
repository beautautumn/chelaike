require "rails_helper"

RSpec.describe Dw::Analysis::AcquisitionPrice do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:analysis) { Dw::Analysis::AcquisitionPrice.new(tianche.id) }
  let(:acquired_at_conditions) { analysis.acquired_at_conditions(Time.zone.now, "month") }
  let(:car_ids_conditions) { { car_id_in: analysis.stock_by_month_car_ids(Time.zone.now) } }

  before do
    travel_to Time.zone.parse("2015-01-01")
  end

  describe "info" do
    context "acquisition info" do
      it "shows info by acquisition_price" do
        result = analysis.stock_info(acquired_at_conditions).first

        expected_result = {
          price_range: "10-30万",
          acquisition_count: 2,
          acquisition_amount: 35.0,
          average_acquisition_amount: 17.5,
          cars_count_proportion: "100.0%",
          acquisition_amount_proportion: "100.0%"
        }
        expect(result).to eq expected_result
      end
    end

    context "stock info" do
      it "shows info by acquisition_price" do
        result = analysis.stock_info(car_ids_conditions).first

        expected_result = {
          price_range: "10-30万",
          acquisition_amount: 35.0,
          acquisition_count: 2,
          average_acquisition_amount: 17.5,
          cars_count_proportion: "100.0%",
          acquisition_amount_proportion: "100.0%"
        }
        expect(result).to eq expected_result
      end
    end
  end
end
