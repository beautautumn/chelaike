require "rails_helper"

RSpec.describe V1::AllianceDashboard::MaintenanceRecordsController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:maintenance_record_uncheck) { maintenance_records(:maintenance_record_uncheck) }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }

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
    login_user(alliance_zhangsan)
  end

  describe "GET /api/v1/alliance_dashboard/maintenance_records/detail" do
    it "returns maintenance record detail while existing" do
      MaintenanceRecordHub.update_all(item_attrs)
      aodi.maintenance_images_attributes = [{ url: "0525091_d432468cf4f366038bf3_72.jpg" }]
      aodi.save
      auth_get :detail, car_id: aodi.id

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
      auth_get :detail, car_id: tumbler.id

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
        auth_get :detail, car_id: tumbler.id
      end.to change { maintenance_record_uncheck.reload.car_id }.from(nil).to(tumbler.id)
    end
  end
end
