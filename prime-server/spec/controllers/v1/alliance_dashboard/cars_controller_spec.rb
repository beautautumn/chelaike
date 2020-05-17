require "rails_helper"

RSpec.describe V1::AllianceDashboard::CarsController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:chuche) { alliances(:chuche) }

  let(:tianche) { companies(:tianche) }
  let(:aodi) { cars(:aodi) }
  let(:black) { "黑色" }

  def images_params
    [
      {
        url: "aa.jpg",
        location: "xxx",
        is_cover: true,
        sort: 0
      },
      {
        url: "xxx.avi",
        location: "xxx",
        is_cover: false,
        sort: 1
      }
    ]
  end

  before do
    chuche.add_company(tianche, "天车")
    chuche.update(alliance_company: alliance_tianche)
    login_user(alliance_zhangsan)
  end

  describe "GET index" do
    context "没有过滤条件" do
      it "列出所有联盟公司里在联盟可见的车辆" do
        aodi.update(alliance_images_attributes: images_params)
        alliance_tianche.add_company(tianche)

        auth_get :index
        expect(response_json[:data].count).to eq 25
      end
    end

    context "附带过滤条件" do
      it "列出所有联盟公司里在联盟可见的车辆" do
        auth_get :index, query: { company_id_eq: tianche.id }
        expect(response_json[:data].count).to eq 25
      end

      it "支持按有无联盟图片过滤" do
        aodi.alliance_images.create(url: "aodi.jpg", is_cover: "true")

        auth_get :index, query: { alliance_images_is_cover_true: "1" }
        return_data = response_json[:data]
        expect(return_data.count).to eq 1
        expect(return_data.first.fetch(:id)).to eq aodi.id
      end
    end
  end

  describe "GET show" do
    it "returns detail for car" do
      auth_get :show, id: aodi.id

      expect(response_json[:data][:id]).to eq aodi.id

      expect(response_json[:data][:prepare_record][:prepare_items].size).to be > 0
    end
  end

  describe "GET out_of_stock" do
    it "列出所有联盟公司里在联盟可见的车辆" do
      alliance_tianche.add_company(tianche)

      auth_get :out_of_stock, query: {
        acquisition_type_eq: "acquisition",
        stock_in_on: "2017-01-17"
      }
      expect(response_json[:data].count).to eq 0
    end
  end

  describe "PUT update" do
    context "有操作权限" do
      before do
        give_authority(alliance_zhangsan, "车辆信息编辑", "牌证信息录入")
      end

      it "可以更新车辆" do
        auth_put :update, id: aodi.id,
                          car: {
                            exterior_color: black,
                            vin: "b123456",
                            show_price_wan: nil,
                            fee_detail: "血崩",
                            manufacturer_configuration: {
                              key: "i'm a configuration."
                            },
                            name: "custom name",
                            attachments: %w(instructions maintenance_manual)
                          },
                          acquisition_transfer: {
                            key_count: 3
                          }

        expect(aodi.reload.name).to eq "custom name"
      end
    end
  end

  describe "PUT update_images" do
    it "更新车辆的联盟图片" do
      auth_put :update_images, id: aodi.id, car: { alliance_images_attributes: images_params }
      expect(aodi.reload.alliance_images.map(&:url)).to match_array %w(aa.jpg xxx.avi)
    end
  end

  describe "GET  联盟后台下载图片操作" do
    it "打包下载联盟图片" do
      auth_put :update_images, id: aodi.id, car: { alliance_images_attributes: images_params }
      auth_get :images_download, id: aodi.id, download_type: "car", image_type: "alliance"
      expect(response.content_type).to eq "application/zip"
    end

    it "打包下载加水印的联盟图" do
      auth_get :images_download, id: aodi.id, download_type: "car", image_type: "alliance_watermark"
      expect(response.content_type).to eq "application/zip"
    end

    it "打包下载车商原图" do
      auth_get :images_download, id: aodi.id, download_type: "car", image_type: "original"
      expect(response.content_type).to eq "application/zip"
    end

    it "打包下载加水印的车商图片" do
      auth_get :images_download, id: aodi.id, download_type: "car", image_type: "water_mark"
      expect(response.content_type).to eq "application/zip"
    end
  end
end
