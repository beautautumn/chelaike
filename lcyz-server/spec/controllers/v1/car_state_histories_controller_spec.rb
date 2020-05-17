require "rails_helper"

RSpec.describe V1::CarStateHistoriesController do
  fixtures :all

  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }

  describe "POST /api/v1/cars/:car_id/car_state_histories" do
    before do
      give_authority(zhangsan, "车辆状态修改")
      login_user(zhangsan)
      travel_to Time.zone.parse("2015-01-15")

      @request_lambda = lambda do
        auth_post :create, car_id: aodi.id,
                           car_state_history: {
                             sellable: false,
                             state: :loaning,
                             occurred_at: "2015-08-20",
                             note: "其他说明"
                           }
        aodi.reload
      end
    end

    it "creates a car state history record" do
      expect { @request_lambda.call }.to change { aodi.car_state_histories.count }.by(1)
    end

    it "changes state of the specify car" do
      @request_lambda.call
      expect(aodi.state).to eq "loaning"
      expect(aodi.sellable).to be_falsy
    end

    it "creates an operation record" do
      expect { @request_lambda.call }.to change { aodi.operation_records.count }.by(1)
    end

    it "changes states_statistic for car" do
      @request_lambda.call

      states_statistic = {
        "in_hall" => 4,
        "preparing" => 5,
        "shipping" => 3,
        "driven_back" => 2
      }

      expect(aodi.count_states_statistic).to eq states_statistic
    end

    it "allows to set predicted_restocked_at to car" do
      predicted_restocked_at = Time.zone.parse("2016-01-10")
      auth_post :create, car_id: aodi.id,
                         car_state_history: {
                           sellable: false,
                           state: :driven_back,
                           occurred_at: "2015-08-20",
                           note: "其他说明",
                           predicted_restocked_at: predicted_restocked_at
                         }

      expect(aodi.reload.predicted_restocked_at).to eq predicted_restocked_at
      expect(aodi.state_note).to eq "其他说明"
    end

    it_should_behave_like "operation_record created" do
      let(:request_query) { @request_lambda.call }
    end

    it "will not pass" do
      auth_post :create, car_id: aodi.id,
                         car_state_history: {
                           sellable: false,
                           state: :loaning,
                           occurred_at: "2012-08-20",
                           note: "其他说明"
                         }

      expect(response_json[:errors][:car_state_history]).to be_present
    end
  end
end
