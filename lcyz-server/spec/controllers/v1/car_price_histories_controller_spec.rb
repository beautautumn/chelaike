require "rails_helper"

RSpec.describe V1::CarPriceHistoriesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    give_authority(zhangsan, "车辆销售定价")
    login_user(zhangsan)
  end

  describe "POST /api/v1/cars/:car_id/car_price_histories" do
    before do
      @request_lambda = lambda do
        auth_post :create,  car_id: aodi.id,
                            car_price_history: {
                              show_price_wan: 10,
                              online_price_wan: 9.6,
                              sales_minimun_price_wan: 9,
                              manager_price_wan: 8.5,
                              alliance_minimun_price_wan: 9.5,
                              note: "123",
                              yellow_stock_warning_days: 22,
                              new_car_guide_price_wan: 10.1,
                              new_car_additional_price_wan: 2.3,
                              new_car_discount: 10.5,
                              new_car_final_price_wan: 3.2,
                              car_attributes: {
                                is_fixed_price: false
                              }
                            }
        aodi.reload
      end
    end

    it "creates a record" do
      expect do
        @request_lambda.call
      end.to change { aodi.car_price_histories.count }.by(1)
    end

    it "修改车辆是否一口价字段" do
      @request_lambda.call

      expect(aodi.reload.is_fixed_price).to eq false
    end

    it "save previous prices" do
      @request_lambda.call
      history = aodi.car_price_histories.last

      expect(history.previous_show_price_wan).to eq 20
      expect(history.show_price_wan).to eq 10
      expect(history.yellow_stock_warning_days).to eq 22
      expect(aodi.reload.yellow_stock_warning_days).to eq 22
    end

    it "saves or udpates 新车指导价等新车价, 并得到相应准确的万元数字" do
      @request_lambda.call

      expect(aodi.new_car_guide_price_wan).to eq 10.1
      expect(aodi.new_car_additional_price_wan).to eq 2.3
      expect(aodi.new_car_discount).to eq 10.5
      expect(aodi.new_car_final_price_wan).to eq 3.2
    end

    it_should_behave_like "operation_record created" do
      let(:request_query) { @request_lambda.call }
    end
  end

  describe "GET /api/v1/cars/:car_id/car_price_histories" do
    it "returns car_price_histories for specify car" do
      auth_get :index, car_id: aodi.id

      result = {
        data: [
          {
            car_id: aodi.id,
            user_id: zhangsan.id,
            user_name: "张三",
            previous_show_price_wan: 20,
            show_price_wan: 17,
            previous_online_price_wan: 19,
            online_price_wan: 17,
            previous_sales_minimun_price_wan: 17,
            sales_minimun_price_wan: 15,
            previous_manager_price_wan: 16,
            manager_price_wan: 13,
            previous_alliance_minimun_price_wan: 16,
            alliance_minimun_price_wan: 14,
            yellow_stock_warning_days: 30,
            red_stock_warning_days: 45,
            created_at: iso8601_format("2015-01-10"),
            note: "nothing",
            new_car_guide_price_wan: 30, # 新车指导价
            new_car_additional_price_wan: 0.5, # 新车加个
            new_car_discount: 0.05, # 新车折扣
            new_car_final_price_wan: 27 # 新车完税价
          }
        ]
      }
      expect(response_json).to eq result
    end
  end
end
