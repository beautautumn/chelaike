require "rails_helper"

RSpec.describe V1::CheRongYi::ReplaceCarsBillsController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:aodi1) { cars(:aodi_1) }
  let(:aodi2) { cars(:aodi_2) }

  before do
    give_authority(zhangsan, "融资管理")
    login_user(zhangsan)
    aodi.update!(estimate_price_wan: 10)
    aodi1.update!(estimate_price_wan: 4)
    aodi2.update!(estimate_price_wan: 9)
  end

  def mock_create_replace_cars_bill
    result = CheRongYi::ReplaceCarsBill.new(
      :id=>1847,
      :current_amount_cents => 5000000,
      :replace_amount_cents => 20000000,
      :state => "replace_apply",
      :apply_code=>"201803082249450000013"
    )
    allow(CheRongYi::Api).to receive(:create_replace_cars_bill).and_return(result)
  end

  describe "POST create" do
    it "创建一条换车单" do
      mock_create_replace_cars_bill
      auth_post :create, loan_bill_id: 54,
                will_replace_car_ids: [aodi.id],
                is_replaced_car_ids: [aodi1.id],
                no_replace_car_ids: [aodi2.id]

      expect(response_json[:data]).to be_present
    end
  end

  def mock_replace_cars_bill_detail
    replace_cars_bill_params =
      {
        :id=>1684,
        :loan_bill_id=>1656,
        :current_amount_cents=>10000000,
        :replace_amount_cents=>11000000,
        :state=>"replace_submitted",
        :debtor_id=>100000,
        :loan_bill_code=>"201803081154181000002",
        :created_at=>" 2018-03-08 15:02:17 ",
        :updated_at=>" 2018-03-08 20:22:52 ",
        :apply_code=>nil,
        :will_replace_cars=>
        [{:id=>1686,
          :brand_name=>"奥迪",
          :series_name=>"奥迪A3",
          :style_name=>"2014款 Sportback 35 TFSI 自动豪华型",
          :company_id=>259435032,
          :shop_id=>1008027379,
          :estimate_price_cents=>20000000,
          :licenced_at=>nil,
          :show_price_cents=>20000000,
          :mileage=>300.9,
          :exterior_color=>"白色",
          :keys_count=>2,
          :vin=>"abc123",
          :check_report_url=>nil,
          :check_report_type=>nil,
          :chelaike_car_id=>346,
          :images=>[{:id=>1687, :url=>"http://tianche-playground.oss-cn-hangzhou.aliyuncs.com/prime/images/00015e45dd3076c15a36c71397348a0c.jpg", :name=>"奥迪头部", :location=>"右侧面", :isCover=>false}]}],
        :is_replaced_cars=>
        [{:id=>1658,
          :brand_name=>"奥迪",
          :series_name=>"一汽-大众奥迪",
          :style_name=>"2016款 Sportback 35 TFSI 进取型",
          :company_id=>100000,
          :shop_id=>100000,
          :estimate_price_cents=>10000000,
          :licenced_at=>nil,
          :show_price_cents=>2600000,
          :mileage=>22.0,
          :exterior_color=>"白色",
          :keys_count=>2,
          :vin=>"12333333333333333",
          :check_report_url=>nil,
          :check_report_type=>nil,
          :chelaike_car_id=>1,
          :images=>
          [{:id=>1660, :url=>"http://prime-server-market.oss-cn-hangzhou.aliyuncs.com/images/B41B66A9-FF68-4BEB-BDE9-D59A6A66A116.jpg", :name=>"测试image", :location=>"", :isCover=>false},
           {:id=>1659, :url=>"http://prime-server-market.oss-cn-hangzhou.aliyuncs.com/images/CF66C152-10BA-4C91-B39F-D2C49291B189.jpg", :name=>"image is 1", :location=>"left_anterior", :isCover=>true}]}],
        :no_replace_cars=>
        [{:id=>1661,
          :brand_name=>"奥迪",
          :series_name=>"一汽-大众奥迪",
          :style_name=>"2016款 Sportback 35 TFSI 进取型",
          :company_id=>100000,
          :shop_id=>100000,
          :estimate_price_cents=>10000000,
          :licenced_at=>nil,
          :show_price_cents=>2600000,
          :mileage=>22.0,
          :exterior_color=>"白色",
          :keys_count=>2,
          :vin=>"12333333333333333",
          :check_report_url=>nil,
          :check_report_type=>nil,
          :chelaike_car_id=>10,
          :images=>
          [{:id=>1663, :url=>"http://prime-server-market.oss-cn-hangzhou.aliyuncs.com/images/B41B66A9-FF68-4BEB-BDE9-D59A6A66A116.jpg", :name=>"测试image", :location=>"", :isCover=>false},
           {:id=>1662, :url=>"http://prime-server-market.oss-cn-hangzhou.aliyuncs.com/images/CF66C152-10BA-4C91-B39F-D2C49291B189.jpg", :name=>"image is 1", :location=>"left_anterior", :isCover=>true}]}],
        :histories=>
        [
          {
            :content_state=>"replace_confirmed",
            :note=>"",
            :created_at=>" 2018-03-08 17:57:16 ",
            content_type: "replace_cars_bill"
          },
          {
            :content_state=>"replace_submitted", :note=>"换车提交", :created_at=>" 2018-03-08 17:37:31 ",
            content_type: "replace_cars_bill"
          },
          {
            :content_state=>"replace_submitted", :note=>"换车提交", :created_at=>" 2018-03-08 17:34:45 ",
            content_type: "replace_cars_bill"
          }
        ]
      }

    replace_cars_bill = CheRongYi::ReplaceCarsBill.new(replace_cars_bill_params)
    allow(CheRongYi::Api).to receive(:replace_cars_bill).and_return(replace_cars_bill)
  end

  describe "GET show" do
    it "得到某条换车单详情" do
      mock_replace_cars_bill_detail
      auth_get :show, id: 1
      expect(response_json[:data]).to be_present
    end
  end
end
