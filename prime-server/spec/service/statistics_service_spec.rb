require "rails_helper"

RSpec.describe StatisticsService do
  let(:operation_user_hash_1) do
    {
      "car_created" => [1],
      "car_updated" => [1, 1],
      "stock_out" => [1]
    }
  end

  let(:operation_user_hash_2) do
    {
      "car_created" => [1, 2, 3],
      "car_updated" => [1],
      "stock_out" => [1, 2, 3]
    }
  end

  let(:operation_user_hash_3) do
    {
      "car_created" => [1],
      "car_priced" => [1, 2, 3],
      "car_updated" => [4],
      "car_reserved" => [5],
      "stock_out" => [5]
    }
  end

  let(:operation_user_hash_4) do
    {
      "car_created" => [1],
      "car_priced" => [1, 2, 3],
      "car_updated" => [4],
      "prepare_record_updated" => [6],
      "car_reserved" => [4, 5, 6],
      "stock_out" => [5]
    }
  end

  describe "#doc_per_car" do
    it "计算每辆车的操作分散率" do
      class StatisticsService
        def test_doc_per_car(operation_user_hash)
          doc_per_car(operation_user_hash)
        end
      end

      service = StatisticsService.new(Time.zone.today - 7.days, Time.zone.today)

      expect(service.test_doc_per_car(operation_user_hash_1)).to eq 0.2
      expect(service.test_doc_per_car(operation_user_hash_2)).to eq 0.2
      expect(service.test_doc_per_car(operation_user_hash_3)).to eq 0.8
      expect(service.test_doc_per_car(operation_user_hash_4)).to eq 1.0
    end
  end
end
