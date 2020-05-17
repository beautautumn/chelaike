require "rails_helper"

RSpec.describe V1::AntQueenRecordsController do
  fixtures :users, :ant_queen_records, :ant_queen_record_hubs, :cars,
           :maintenance_settings, :companies, :tokens

  let(:zhangsan) { users(:zhangsan) }
  let(:ant_queen_record_uncheck) { ant_queen_records(:ant_queen_record_uncheck) }
  let(:records) { AntQueenRecord.all }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }
  let(:user_token) { tokens(:user_token) }
  let(:company_token) { tokens(:company_token) }

  before do
    login_user(zhangsan)
    user_token.update!(balance: 100)
  end

  describe "GET /api/v1/ant_queen_records" do
    it "returns ant_queen records" do
      auth_get :index

      expect(response_json[:data].size).to eq 3
    end

    it "returns sort by date" do
      auth_get :index

      expect(response_json[:data].map { |i| i[:id] })
        .to eq records.order(last_fetch_at: :desc).map(&:id)
    end

    it "query by vin" do
      auth_get :index, query: { vin: ant_queen_record_uncheck.vin }

      expect(response_json[:data].size).to eq 1
      expect(response_json[:data].first[:vin]).to eq ant_queen_record_uncheck.vin
    end

    it "query by not existing vin" do
      auth_get :index, query: { vin: "xxxxxx" }

      expect(response_json[:data].size).to eq 0
    end

    it "humanize last_fetch_by" do
      auth_get :index, query: { vin: ant_queen_record_uncheck.vin }
      expect(response_json[:data].first[:date]).to eq "2天前"
    end

    it "returns limit" do
      Token.destroy_all
      auth_get :index, query: { vin: ant_queen_record_uncheck.vin }
      expect(response_json[:meta][:balance]).to eq "0.00"
    end
  end

  describe "GET /api/v1/ant_queen_records/#id" do
    before do
      give_authority(zhangsan, "维保详情查看")
    end

    it "returns ant_queen record detail" do
      auth_get :show, id: ant_queen_record_uncheck.id
      expect(response_json[:data].keys)
        .to match_array [:ant_queen_record_hub_id, :brand_name, :car_id, :id,
                         :last_time_to_shop, :notify_time, :number_of_accidents,
                         :result_description, :result_images, :series_name,
                         :state, :stored, :style_name, :total_mileage, :vin,
                         :car_info, :car_status, :query_text, :text_contents_json,
                         :text_img_json]
    end

    it "updates state to checked" do
      expect do
        auth_get :show, id: ant_queen_record_uncheck.id
      end.to change { ant_queen_record_uncheck.reload.state }
        .from("unchecked")
        .to("checked")
    end

    it "根据参数得到mini的返回" do
      auth_get :show, id: ant_queen_record_uncheck.id, only_app: true
      expect(response_json[:data].keys).to match_array [:id, :brand_name, :stored,
                                                        :state, :car_id, :vin, :shared_url]
    end
  end

  describe "#fetch" do
    let(:invalid_vin) { "LSVAU033972103735" }
    let(:valid_vin) { "LHGRB186072026733" }

    # it "return 403 if no Authorization" do
    #   auth_post :fetch, query: { vin: "xxx", is_image: false }
    #   expect(response.status).to be 403
    #   expect(response_json[:message]).to eq "您暂无维保查询权限"
    # end

    it "return 402 if no existing quantity" do
      Token.destroy_all
      allow_any_instance_of(AntQueenRecordPolicy).to receive(:fetch?).and_return(:true)
      allow_any_instance_of(AntQueenRecordPolicy).to receive(:buy?).and_return(:true)

      VCR.use_cassette("ant_queen_buy_fail", allow_playback_repeats: true) do
        auth_post :fetch, query: { vin: "xxx" }
        expect(response.status).to be 402
        expect(response_json[:message]).to eq "没有剩余报告可用了，赶紧买个套餐吧"
      end
    end

    context "existing quantity" do
      before do
        allow_any_instance_of(AntQueenRecordPolicy).to receive(:fetch?).and_return(:true)
      end

      it "returns 200" do
        VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
          auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
          expect(response.status).to be 200
        end
      end

      it "spend tokens if existing quantity" do
        VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
          price = AntQueenRecord.unit_price(
            car_brand_id: ant_queen_record_uncheck.car_brand_id,
            company: zhangsan.company
          )
          expect do
            auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
          end.to change { user_token.reload.balance }
            .by(-price)
        end
      end

      it "记录账单" do
        VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
          expect do
            auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
          end.to change { TokenBill.count }.by 1
        end
      end

      context "#expcation" do
        it "return 402 if rescue" do
          VCR.use_cassette("ant_queen_buy_fail", allow_playback_repeats: true) do
            auth_post :fetch, query: { vin: valid_vin, brand_id: 19 }
            expect(response.status).to be 402
            expect(response_json[:message]).to eq "服务暂不可用，请稍后重试"
          end
        end
      end
    end
  end

  describe "#refetch" do
    # it "return 403 if no Authorization" do
    #   auth_post :refetch, id: ant_queen_record_uncheck.id
    #   expect(response.status).to be 403
    #   expect(response_json[:message]).to eq "您暂无维保查询权限"
    # end

    it "return 402 if no existing quantity" do
      Token.destroy_all
      allow_any_instance_of(AntQueenRecordPolicy).to receive(:refetch?).and_return(true)
      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        auth_post :refetch, id: ant_queen_record_uncheck.id

        expect(response.status).to be 402
        expect(response_json[:message]).to eq "没有剩余报告可用了，赶紧买个套餐吧"
      end
    end

    it "not spend tokens now if existing quantity" do
      allow_any_instance_of(AntQueenRecordPolicy).to receive(:refetch?).and_return(true)

      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        price = AntQueenRecord.unit_price(
          car_brand_id: ant_queen_record_uncheck.car_brand_id,
          company: zhangsan.company
        )
        expect do
          auth_post :refetch, id: ant_queen_record_uncheck.id
        end.to change { user_token.reload.balance }
          .by(-price)
      end
    end
  end
end
