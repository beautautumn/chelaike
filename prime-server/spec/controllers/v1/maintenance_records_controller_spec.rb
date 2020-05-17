require "rails_helper"

RSpec.describe V1::MaintenanceRecordsController do
  fixtures :users, :maintenance_records, :maintenance_record_hubs, :cars, :maintenance_settings,
           :ant_queen_records, :ant_queen_record_hubs, :companies, :tokens

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:maintenance_record_uncheck) { maintenance_records(:maintenance_record_uncheck) }
  let(:hub) { maintenance_record_uncheck.maintenance_record_hub }
  let(:records) { MaintenanceRecord.all }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }
  let(:user_token) { tokens(:user_token) }
  let(:company_token) { tokens(:company_token) }

  let(:item_attrs) do
    { items: [{ date: "2014-10-01",
                mileage: "9956",
                category: "保养",
                item: "进行带附加组件的 A 类保养范围；",
                material: "机滤；  机油；"
              }]
    }
  end

  before do
    login_user(zhangsan)
    user_token.update(balance: 100)
  end

  describe "GET /api/v1/maintenance_records" do
    it "returns maintenance records" do
      auth_get :index

      expect(response_json[:data].size).to eq 3
    end

    it "returns sort by date" do
      auth_get :index

      expect(response_json[:data].map { |i| i[:id] })
        .to eq records.order(last_fetch_at: :desc).map(&:id)
    end

    it "query by vin" do
      auth_get :index, query: { vin: maintenance_record_uncheck.vin }

      expect(response_json[:data].size).to eq 1
      expect(response_json[:data].first[:vin]).to eq maintenance_record_uncheck.vin
    end

    it "query by not existing vin" do
      auth_get :index, query: { vin: "xxxxxx" }

      expect(response_json[:data].size).to eq 0
    end

    it "humanize last_fetch_by" do
      auth_get :index, query: { vin: maintenance_record_uncheck.vin }
      expect(response_json[:data].first[:date]).to eq "2天前"
    end

    it "returns limit" do
      auth_get :index, query: { vin: maintenance_record_uncheck.vin }
      expect(response_json[:meta][:balance]).to eq company_token.balance.to_s
    end
  end

  describe "GET /api/v1/maintenance_records/#id" do
    it "returns maintenance record detail" do
      give_authority(zhangsan, "维保详情查看")

      MaintenanceRecordHub.update_all(item_attrs)

      auth_get :show, id: maintenance_record_uncheck.id

      expect(response_json[:data][:items][0].keys)
        .to match_array [:date, :mileage, :category, :item, :material]
    end

    it "updates state to checked" do
      give_authority(zhangsan, "维保详情查看")
      MaintenanceRecordHub.update_all(item_attrs)

      expect do
        auth_get :show, id: maintenance_record_uncheck.id
      end.to change { maintenance_record_uncheck.reload.state }
        .from("unchecked")
        .to("checked")
    end
  end

  describe "GET /api/v1/maintenance_records/detail" do
    before do
      give_authority(zhangsan, "维保详情查看")
    end

    it "returns maintenance record detail while existing" do
      MaintenanceRecordHub.update_all(item_attrs)
      aodi.maintenance_images_attributes = [{ url: "0525091_d432468cf4f366038bf3_72.jpg" }]
      aodi.save
      auth_get :detail, query: { car_id: aodi.id }

      expect(response.status).to be 200
      expect(response_json[:data][:maintenance_record][:items][0].keys)
        .to match_array [:date, :mileage, :category, :item, :material]
      expect(response_json[:data][:ant_queen_record].keys)
        .to match_array [:ant_queen_record_hub_id, :brand_name, :car_id, :id,
                         :last_time_to_shop, :notify_time, :number_of_accidents,
                         :result_description, :result_images, :series_name,
                         :state, :stored, :style_name, :total_mileage, :vin,
                         :car_info, :car_status, :query_text, :text_contents_json,
                         :text_img_json]
      expect(response_json[:data][:ant_queen_record][:ant_queen_record_hub_id])
        .to be_present
      expect(response_json[:data][:maintenance_images].size)
        .to eq 1
    end

    it "returns 200" do
      auth_get :detail, query: { car_id: tumbler.id }

      expect(response.status).to be 200
      expect(response_json[:data][:maintenance_record][:maintenance_record_hub_id])
        .to be_nil
      expect(response_json[:data][:ant_queen_record][:ant_queen_record_hub_id])
        .to be_nil
      expect(response_json[:data][:maintenance_images]).to eq []
    end

    it "updates maintenance_record car_id" do
      maintenance_record_uncheck.update(car_id: nil, vin: tumbler.vin)

      expect do
        auth_get :detail, query: { car_id: tumbler.id }
      end.to change { maintenance_record_uncheck.reload.car_id }.from(nil).to(tumbler.id)
    end
  end

  describe "#warehousing" do
    before do
      allow_any_instance_of(MaintenanceRecordPolicy).to receive(:warehousing?).and_return(:true)
    end

    it "returns 200" do
      auth_get :warehousing, id: maintenance_record_uncheck.id

      expect(response.status).to eq 200
    end

    it "returns attribtes" do
      auth_get :warehousing, id: maintenance_record_uncheck.id

      data = response_json[:data]
      expect(data[:vin]).to eq hub.vin
      expect(data[:brand]).to eq hub.brand
    end
  end

  describe "POST /api/v1/maintenance_records/upload_images" do
    it "creates new maintenance_records if not existing" do
      auth_post :upload_images,
                car_id: aodi.id,
                maintenance_images_attributes: [{ url: "0525091_d432468cf4f366038bf3_72.jpg" }]

      expect(response.status).to be 200
      expect(aodi.reload.maintenance_images.map(&:url))
        .to eq ["0525091_d432468cf4f366038bf3_72.jpg"]
    end

    it "updates maintenance_records if existing" do
      auth_post :upload_images,
                car_id: aodi.id,
                maintenance_images_attributes: [{ url: "0525091_d432468cf4f366038bf3_72.jpg" }]

      expect(response.status).to be 200
      expect(response_json[:data][:maintenance_images].map { |i| i[:url] })
        .to eq ["0525091_d432468cf4f366038bf3_72.jpg"]
      expect(aodi.maintenance_images.map(&:url))
        .to eq ["0525091_d432468cf4f366038bf3_72.jpg"]
    end

    it "delete images" do
      images = ["0525091_d432468cf4f366038bf3_72.jpg", "0525091_d432468cf4f366038bf3_73.jpg"]
      images_params = images.map { |i| { url: i } }

      auth_post :upload_images,
                car_id: aodi.id,
                maintenance_images_attributes: images_params

      expect(response.status).to be 200
      expect(aodi.maintenance_images.map(&:url)).to match_array images

      image = aodi.maintenance_images.where(url: "0525091_d432468cf4f366038bf3_72.jpg").first
      auth_post :upload_images,
                car_id: aodi.id,
                maintenance_images_attributes: [{ id: image.id, _destroy: true }]

      expect(response.status).to be 200
      expect(aodi.reload.maintenance_images.map(&:url))
        .to eq ["0525091_d432468cf4f366038bf3_73.jpg"]
    end
  end

  describe "#fetch" do
    let(:invalid_vin) { "LSVAU033972103735" }
    let(:valid_vin) { "LHGRB186072026733" }

    # it "return 403 if no Authorization" do
    #   auth_post :fetch, query: { vin: "xxx" }
    #   expect(response.status).to be 403
    #   expect(response_json[:message]).to eq "您暂无维保查询权限"
    # end

    it "return 402 if no existing quantity" do
      Token.destroy_all
      allow_any_instance_of(MaintenanceRecordPolicy).to receive(:fetch?).and_return(:true)
      allow_any_instance_of(MaintenanceRecordPolicy).to receive(:buy?).and_return(:true)

      VCR.use_cassette("chejianding_buy_fail") do
        auth_post :fetch, query: { vin: "xxx" }
        expect(response.status).to be 402
        expect(response_json[:message]).to eq "没有剩余报告可用了，赶紧买个套餐吧"
      end
    end

    context "existing quantity" do
      before do
        allow_any_instance_of(MaintenanceRecordPolicy).to receive(:fetch?).and_return(:true)
      end

      it "returns 200" do
        VCR.use_cassette("chejianding_buy_success") do
          auth_post :fetch, query: { vin: valid_vin }
          expect(response.status).to be 200
        end
      end

      it "spend tokens if existing quantity" do
        VCR.use_cassette("chejianding_buy_success") do
          expect do
            auth_post :fetch, query: { vin: valid_vin }
          end.to change { user_token.reload.balance }
            .by(-MaintenanceRecord.unit_price)
        end
      end

      it "生成账单" do
        VCR.use_cassette("chejianding_buy_success") do
          auth_post :fetch, query: { vin: valid_vin }
          bill = TokenBill.last
          expect(TokenBill.count).to eq 1
          expect(bill.action_type).to eq "maintenance_query"
        end
      end

      it "先从个人车币里扣除" do
        Token.destroy_all

        user_token = Token.create!(
          user_id: zhangsan.id,
          balance: 100,
          token_type: :user
        )

        company_token = Token.create!(
          company_id: zhangsan.company_id,
          balance: 100,
          token_type: :company
        )

        VCR.use_cassette("chejianding_buy_success") do
          auth_post :fetch, query: { vin: valid_vin }
          expect(user_token.reload.balance).to eq 100 - MaintenanceRecord.unit_price
          expect(company_token.reload.balance).to eq 100
        end
      end

      it "handles chejianding_buy_fail exception" do
        VCR.use_cassette("chejianding_buy_fail") do
          auth_post :fetch, query: { vin: invalid_vin }
          expect(response.status).to be 422
          expect(response_json[:message]).to eq "暂不支持此品牌"
          expect(response_json[:status]).to eq 4
        end
      end
    end
  end

  describe "#refetch" do
    # it "return 403 if no Authorization" do
    #   auth_post :refetch, id: maintenance_record_uncheck.id
    #   expect(response.status).to be 403
    #   expect(response_json[:message]).to eq "您暂无维保查询权限"
    # end

    it "return 402 if no existing quantity" do
      Token.destroy_all
      allow_any_instance_of(MaintenanceRecordPolicy).to receive(:refetch?).and_return(true)
      auth_post :refetch, id: maintenance_record_uncheck.id

      expect(response.status).to be 402
      expect(response_json[:message]).to eq "没有剩余报告可用了，赶紧买个套餐吧"
    end

    it "not spend tokens now if existing quantity" do
      user_token.update!(balance: 100)
      allow_any_instance_of(MaintenanceRecordPolicy).to receive(:refetch?).and_return(true)

      VCR.use_cassette("chejianding_buy_success") do
        expect do
          auth_post :refetch, id: maintenance_record_uncheck.id
        end.to change { user_token.reload.balance }
          .by(-MaintenanceRecord.unit_price)
      end
    end
  end

  describe "#statistics" do
    it "return data" do
      give_authority(zhangsan, "维保统计查看")

      auth_get :statistics, query: { fetch_by: zhangsan.id }
      expect(response.status).to be 200
      expect(response_json[:data]).to be_present
    end

    it "export data" do
      give_authority(zhangsan, "维保统计查看")

      auth_get :export, query: { fetch_by: zhangsan.id }
      expect(response.status).to be 200
    end
  end

  describe "GET share_record" do
    it "根据平台及ID得到可分享的url" do
      auth_get :share_record, provider_id: 4, id: maintenance_record_uncheck.id

      expect(response_json).to be_present
    end
  end

  describe "GET shared_detail" do
    it "得到这个维保记录详情" do
      shared_key = MaintenanceRecord.shared_key("che_jian_ding", maintenance_record_uncheck.id)
      get :shared_detail, shared_key: shared_key
      expect(response_json).to be_present
    end
  end
end
