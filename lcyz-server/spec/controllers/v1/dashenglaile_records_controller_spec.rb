require "rails_helper"

RSpec.describe V1::DashenglaileRecordsController do
  fixtures :users, :dashenglaile_records, :dashenglaile_record_hubs, :cars,
           :maintenance_settings, :companies, :tokens

  let(:zhangsan) { users(:zhangsan) }
  let(:dashenglaile_record_uncheck) { dashenglaile_records(:dashenglaile_record_uncheck) }
  let(:records) { DashenglaileRecord.all }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }
  let(:user_token) { tokens(:user_token) }
  let(:company_token) { tokens(:company_token) }

  before do
    login_user(zhangsan)
    user_token.update!(balance: 100)
    mock_prices
  end

  describe "GET /api/v1/dashenglaile_records" do
    it "returns dashenglaile records" do
      auth_get :index

      expect(response_json[:data].size).to eq 3
    end

    it "returns sort by date" do
      auth_get :index

      expect(response_json[:data].map { |i| i[:id] })
        .to eq records.order(last_fetch_at: :desc).map(&:id)
    end

    it "query by vin" do
      auth_get :index, query: { vin: dashenglaile_record_uncheck.vin }

      expect(response_json[:data].size).to eq 1
      expect(response_json[:data].first[:vin]).to eq dashenglaile_record_uncheck.vin
    end

    it "query by not existing vin" do
      auth_get :index, query: { vin: "xxxxxx" }

      expect(response_json[:data].size).to eq 0
    end

    it "humanize last_fetch_by" do
      auth_get :index, query: { vin: dashenglaile_record_uncheck.vin }
      expect(response_json[:data].first[:date]).to eq "2天前"
    end

    it "returns limit" do
      Token.destroy_all
      auth_get :index, query: { vin: dashenglaile_record_uncheck.vin }
      expect(response_json[:meta][:balance]).to eq "0.00"
    end
  end

  describe "GET /api/v1/dashenglaile_records/#id" do
    before do
      give_authority(zhangsan, "维保详情查看")
    end

    it "returns dashenglaile record detail" do
      auth_get :show, id: dashenglaile_record_uncheck.id
      expect(response_json[:data].keys)
        .to match_array [:brand_name, :car_id, :dashenglaile_record_hub_id, :id,
                         :last_time_to_shop, :notify_time, :number_of_accidents,
                         :result_description, :result_images, :car_info, :query_text,
                         :series_name, :state, :stored, :style_name, :new_car_warranty,
                         :total_mileage, :vin, :emission_standard, :car_status,
                         :state_info, :allow_share]
    end

    it "updates state to checked" do
      expect do
        auth_get :show, id: dashenglaile_record_uncheck.id
      end.to change { dashenglaile_record_uncheck.reload.state }
        .from("unchecked")
        .to("checked")
    end
  end

  describe "#fetch" do
    let(:invalid_vin) { "LSVAU033972103735" }
    let(:valid_vin) { "LHGRB186072026733" }
    let(:honda_vin) { "LHGRB3855D8011186" }
    let(:image) { "http://image.chelaike.com/images/d111bfe9-980f-4a95-95f0-676803323fa1.jpg" }

    # it "return 403 if no Authorization" do
    #   auth_post :fetch, query: { vin: "xxx", is_image: false }
    #   expect(response.status).to be 403
    #   expect(response_json[:message]).to eq "您暂无维保查询权限"
    # end

    it "return 402 if no existing quantity" do
      Token.destroy_all
      allow_any_instance_of(DashenglaileRecordPolicy).to receive(:fetch?).and_return(:true)
      allow_any_instance_of(DashenglaileRecordPolicy).to receive(:buy?).and_return(:true)

      VCR.use_cassette("dashenglaile_buy_success", allow_playback_repeats: true) do
        auth_post :fetch, query: { vin: "xxx" }
        expect(response.status).to be 402
        expect(response_json[:message]).to eq "没有剩余报告可用了，赶紧买个套餐吧"
      end
    end

    context "existing quantity" do
      before do
        allow_any_instance_of(DashenglaileRecordPolicy).to receive(:fetch?).and_return(:true)
        Token.create(company_id: zhangsan.company_id, balance: 200000)
      end

      it "returns 200" do
        VCR.use_cassette("dashenglaile_buy_success_3", allow_playback_repeats: true) do
          auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
          expect(response.status).to be 200
        end
      end

      it "spend tokens if existing quantity" do
        VCR.use_cassette("dashenglaile_buy_success_4", allow_playback_repeats: true) do
          price = DashenglaileRecord.unit_price(
            car_brand_id: dashenglaile_record_uncheck.car_brand_id,
            company: zhangsan.company
          )
          # bloc = proc { Token.where(company_id: zhangsan.company_id).first.balance }
          expect do
            auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
          end.to change { user_token.reload.balance }
            .by(-price)
        end
      end

      it "works with image" do
        VCR.use_cassette("dashenglaile_buy_success_image", allow_playback_repeats: true) do
          price = DashenglaileRecord.unit_price(
            car_brand_id: dashenglaile_record_uncheck.car_brand_id,
            company: zhangsan.company
          )
          expect do
            auth_post :fetch, query: { vin: image, brand_id: 19, is_image: true }
          end.to change { user_token.reload.balance }
            .by(-price)
        end
      end

      it "记录账单" do
        VCR.use_cassette("dashenglaile_buy_success_3", allow_playback_repeats: true) do
          expect do
            auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
          end.to change { TokenBill.count }.by 1
        end
      end

      context "#exception" do
        it "return 402 if rescue" do
          VCR.use_cassette("dasheng_buy_fail", allow_playback_repeats: true) do
            auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
            expect(response.status).to be 402
            expect(response_json[:message]).to eq "服务暂不可用，请稍后重试"
          end
        end

        it "return 402 if brand pause" do
          VCR.use_cassette("dasheng_brand_pause", allow_playback_repeats: true) do
            auth_post :fetch, query: { vin: honda_vin }
            expect(response.status).to be 402
            expect(response_json[:message]).to eq "该品牌系统维护, 暂不支持查询"
          end
        end
      end
    end
  end

  describe "#refetch" do
    # it "return 403 if no Authorization" do
    #   auth_post :refetch, id: dashenglaile_record_uncheck.id
    #   expect(response.status).to be 403
    #   expect(response_json[:message]).to eq "您暂无维保查询权限"
    # end

    it "return 402 if no existing quantity" do
      Token.destroy_all
      allow_any_instance_of(DashenglaileRecordPolicy).to receive(:refetch?).and_return(true)
      VCR.use_cassette("dashenglaile_buy_success", allow_playback_repeats: true) do
        auth_post :refetch, id: dashenglaile_record_uncheck.id

        expect(response.status).to be 402
        expect(response_json[:message]).to eq "没有剩余报告可用了，赶紧买个套餐吧"
      end
    end

    it "not spend tokens now if existing quantity" do
      allow_any_instance_of(DashenglaileRecordPolicy).to receive(:refetch?).and_return(true)
      Token.create(company_id: zhangsan.company_id, balance: 20000)

      VCR.use_cassette("dashenglaile_buy_success_5", allow_playback_repeats: true) do
        price = DashenglaileRecord.unit_price(
          car_brand_id: dashenglaile_record_uncheck.car_brand_id,
          company: zhangsan.company
        )
        expect do
          auth_post :refetch, id: dashenglaile_record_uncheck.id
        end.to change { user_token.reload.balance }
          .by(-price)
      end
    end
  end
end
