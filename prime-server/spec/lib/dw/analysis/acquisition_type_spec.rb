require "rails_helper"

RSpec.describe Dw::Analysis::AcquisitionType do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:analysis) { Dw::Analysis::AcquisitionType.new(tianche.id) }
  let(:acquired_at_conditions) { analysis.acquired_at_conditions(Time.zone.now, "day") }
  let(:car_ids_conditions) { { car_id_in: analysis.stock_by_month_car_ids(Time.zone.now) } }

  before do
    travel_to Time.zone.parse("2015-01-01")
  end

  describe "acquisition info" do
    context "acquisition info" do
      it "shows info by acquisition type" do
        result = analysis.stock_info(acquired_at_conditions)

        expected_result = {
          acquisition_types: ["acquisition"],
          cars_total_count: 1,
          total_acquisition_amount: 20.0,
          detail: {
            "acquisition" => {
              acquisition_count: 1,
              acquisition_amount: 20.0,
              cars_count_proportion: "100.0%",
              acquisition_amount_proportion: "100.0%"
            }
          }
        }
        expect(result).to eq expected_result
      end
    end

    context "stock info" do
      it "shows info by acquisition type" do
        result = analysis.stock_info(car_ids_conditions)

        expected_result = {
          acquisition_types: %w(acquisition cooperation),
          cars_total_count: 2,
          total_acquisition_amount: 35.0,
          detail: {
            "acquisition" => {
              acquisition_amount: 20.0,
              acquisition_count: 1,
              cars_count_proportion: "50.0%",
              acquisition_amount_proportion: "57.1%"
            },
            "cooperation" => {
              acquisition_amount: 15.0,
              acquisition_count: 1,
              cars_count_proportion: "50.0%",
              acquisition_amount_proportion: "42.9%"
            }
          }
        }

        acquisition_types = result.delete(:acquisition_types)
        expect(acquisition_types).to match_array(%w(acquisition cooperation))
        expect(result).to eq expected_result.slice!(:acquisition_types)
      end
    end
  end
end
