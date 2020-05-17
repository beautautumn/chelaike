require "rails_helper"

RSpec.describe Dw::Analysis::User do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:stock_out_at) { Time.zone.parse("2015-04-20") }
  let(:analysis) { Dw::Analysis::User.new(tianche.id) }
  let(:acquired_at_conditions) { analysis.acquired_at_conditions(Time.zone.now, "day") }
  let(:stock_out_at_conditions) { analysis.stock_out_at_conditions(Time.zone.now, "day") }
  let(:car_ids_conditions) { { car_id_in: analysis.stock_by_month_car_ids(Time.zone.now) } }

  describe "stock info" do
    before do
      travel_to Time.zone.parse("2015-01-01")
    end

    context "acquisition_info" do
      it "shows all acquisition info by acquirers" do
        result = analysis.stock_info(acquired_at_conditions).fetch(:detail).first

        statistic = result.fetch("acquisition_type_statistic")

        expect(statistic).to eq("acquisition" => 1)
      end
    end

    context "stock_info" do
      it "shows all stock info by acquirers" do
        result = analysis.stock_info(car_ids_conditions).fetch(:detail).first

        statistic = result.fetch("acquisition_type_statistic")

        expect(statistic).to eq("acquisition" => 1, "cooperation" => 1)
      end
    end
  end

  describe "out of stock info" do
    before do
      travel_to Time.zone.parse("2015-01-20")
    end

    it "shows all out of stock info by acquirers" do
      result = analysis.out_of_stock_info(
        stock_out_at_conditions
      ).fetch(:detail)

      expect(result).to be_present
    end

    it "shows all out of stock info by seller" do
      result = analysis.out_of_stock_info(
        stock_out_at_conditions, target: "seller"
      ).fetch(:detail)

      expect(result).to be_present
    end
  end
end
