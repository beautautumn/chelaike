require "rails_helper"

RSpec.describe Alliance::CarsCreatedStatisticService do
  fixtures :all

  let(:warner) { companies(:warner) }
  let(:avengers) { alliances(:avengers) }
  let(:zhangsan) { users(:zhangsan) }
  let!(:aodi) do
    car = cars(:aodi)
    car.update_columns(
      company_id: warner.id,
      created_at: Time.zone.now.beginning_of_day
    )

    car
  end

  describe "#execute_statistic" do
    it "analyses data" do
      result = Alliance::CarsCreatedStatisticService.new.execute_statistic(avengers)

      expect(result[zhangsan.id]).to be_present
      expect(result[zhangsan.id][aodi.id]).to be_present
    end
  end

  describe "#execute" do
    it "create a operation_record" do
      expect do
        Alliance::CarsCreatedStatisticService.new.execute
      end.to change { OperationRecord.count }.by(1)
    end
  end
end
