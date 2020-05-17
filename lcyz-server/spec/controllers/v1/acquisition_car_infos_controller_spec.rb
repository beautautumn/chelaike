require "rails_helper"

RSpec.describe V1::AcquisitionCarInfosController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:disney) { shops(:disney) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:aodi) { cars(:aodi) }
  let(:acquisition_aodi) { acquisition_car_infos(:aodi) }
  let(:acquisition_comment) { acquisition_car_comments(:aodi_comment) }
  let(:zhangsan_tianche_sale_group) { conversations(:zhangsan_tianche_sale_group) }
  let(:avengers) { alliances(:avengers) }

  before do
    acquisition_aodi.update(company_id: tianche.id)
    give_authority(zhangsan, "车辆新增入库")
    login_user(zhangsan)
  end

  def acquisition_car_info_params
    acquisition_aodi.attributes.except!(
      "id", "acquirer_id", "state"
    )
  end

  def manufacturer_configuration
    arr = [
      { fields: [{ name: "厂商", type: "text", value: "一汽-大众奥迪" },
                 { name: "车身结构", type: "text", value: "5门5座两厢车" }],
        name: "基本参数"
      },
      { fields: [{ name: "轴距(mm)", type: "text", value: "2629" },
                 { name: "车身结构", type: "text", value: "两厢车" }],
        name: "车身"
      }]

    { manufacturer_configuration: arr }
  end

  describe "GET index" do
    context "没有过滤搜索" do
      it "如果有管理权限，返回所有本公司收车评估" do
        give_authority(lisi, "全部出售客户管理")
        login_user(lisi)
        auth_get :index, page: 1
        expect(response_json[:data].first[:id]).to eq acquisition_aodi.id
      end

      it "如果是普通权限，返回本人创建的收车评估" do
        give_authority(zhangsan, "出售客户跟进")
        login_user(zhangsan)
        auth_get :index
        expect(response_json[:data].first[:id]).to eq acquisition_aodi.id
      end
    end

    context "有过滤搜索" do
      it "根据品牌进行过滤" do
        auth_get :index, query: { brand_name_eq: acquisition_aodi.brand_name }

        expect(response_json[:data].first[:id]).to eq acquisition_aodi.id
      end
    end
  end

  describe "GET brands" do
    it "得到所有收车信息里的品牌" do
      auth_get :brands
      result_hash = [
        { first_letter: "A", name: "奥迪" }
      ]

      expect(response_json[:data]).to eq result_hash
    end
  end

  describe "GET series" do
    it "得到所有收车信息里的车系" do
      VCR.use_cassette("company_series") do
        auth_get :series, brand: { name: "奥迪" }
        result_hash = [
          { manufacturer_name: "一汽-大众奥迪", series: [{ name: "奥迪A3" }] }
        ]

        expect(response_json[:data]).to eq result_hash
      end
    end
  end

  describe "GET levels" do
    it "得到所有的客户意向等级" do
      auth_get :levels
      expect(response_json[:data]).to eq ["A级"]
    end
  end

  describe "POST create" do
    it "创建一条新的发车信息" do
      request_params = acquisition_car_info_params.merge(manufacturer_configuration)
                                                  .merge(prepare_estimated_yuan: "")
                                                  .merge(owner_info: nil)
      expect do
        auth_post :create, acquisition_car_info: request_params,
                           chat_id: zhangsan_tianche_sale_group.id,
                           chat_type: "group"
      end.to change { AcquisitionCarInfo.count }.by(1)

      acquisition_car = AcquisitionCarInfo.last
      expect(acquisition_car.acquirer).to eq zhangsan
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET show" do
    it "返回这个收车信息的详情" do
      acquisition_aodi.update(company: tianche)
      acquisition_comment.update(
        acquisition_car_info: acquisition_aodi,
        is_seller: false
      )
      auth_get :show, id: acquisition_aodi
      expect(response_json[:data][:id]).to eq acquisition_aodi.id
    end
  end

  describe "POST forwarding" do
    it "记录把这条收车信息转发到某个群" do
      expect do
        auth_post :forwarding, id: acquisition_aodi, chat: { id: 23, type: "group" }
      end.to change { acquisition_aodi.publish_records.count }.by(1)
    end
  end

  describe "PUT update" do
    before do
      acquisition_aodi.update(acquirer: zhangsan)
    end

    context "这条收车信息未分配" do
      before do
        acquisition_aodi.update(acquirer_id: nil)
      end

      it "可以允许有收购经理权限的用户更新" do
        give_authority(zhangsan, "全部出售客户管理")
        login_user(zhangsan)

        auth_put :update, id: acquisition_aodi,
                          acquisition_car_info: acquisition_car_info_params.merge(
                            displacement: 2.0,
                            mileage: 1.3,
                            images: [],
                            note_audios: []
                          )
        expect(acquisition_aodi.reload.mileage).to eq 1.3
      end

      it "不允许其他用户更新" do
        give_authority(zhangsan, "出售客户管理")
        login_user(zhangsan)

        auth_put :update, id: acquisition_aodi,
                          acquisition_car_info: acquisition_car_info_params.merge(
                            displacement: 2.0,
                            mileage: 1.3,
                            images: [],
                            note_audios: []
                          )
        expect(response.status).to eq 403
      end
    end

    context "其他用户" do
      before do
        login_user(lisi)
      end

      it "禁止操作" do
        auth_put :update, id: acquisition_aodi
        expect(response.status).to eq 403
      end
    end

    context "发布信息本人" do
      before do
        login_user(zhangsan)
      end

      it "可以修改" do
        auth_put :update, id: acquisition_aodi,
                          acquisition_car_info: acquisition_car_info_params.merge(
                            displacement: 2.0,
                            mileage: 1.3,
                            images: [],
                            note_audios: []
                          )

        acquisition_aodi.reload
        expect(acquisition_aodi.images).to eq []
        expect(acquisition_aodi.displacement).to eq 2.0
        expect(acquisition_aodi.mileage).to eq 1.3
      end
    end
  end

  def confirmation_params
    {
      acquisition_price_wan: 10,
      acquired_at: Date.new(2016, 7, 28),
      company_id: tianche.id,
      shop_id: disney.id,
      alliance_id: avengers.id,
      cooperate_companies: [warner.id, tianche.id]
    }
  end

  describe "POST confirm_acquisition" do
    it "能正常访问" do
      auth_post :confirm_acquisition, id: acquisition_aodi,
                                      acquisition_confirmation: confirmation_params
      acquisition_aodi.reload
      expect(acquisition_aodi.state).to eq "finished"
      expect(acquisition_aodi.car_id).to be_present
      expect(acquisition_aodi.closing_cost_wan).to eq 10
      expect(response_json[:data]).to be_present
    end
  end

  describe "PUT assign" do
    context "用户有 全部求购客户管理 or 全部客户管理" do
      before do
        give_authority(zhangsan, "全部客户管理")
        login_user(zhangsan)
        acquisition_aodi.update(acquirer_id: nil)
      end

      it "可以把一个收车评估分配给其他人" do
        auth_put :assign, id: acquisition_aodi.id,
                          acquirer_id: lisi.id
        expect(acquisition_aodi.reload.acquirer).to eq lisi
      end
    end

    context "普通用户" do
      before do
        give_authority(zhangsan, "出售客户跟进")
        login_user(zhangsan)
        acquisition_aodi.update(acquirer_id: nil)
      end

      it "可以把一个收车评估分配给其他人" do
        auth_put :assign, id: acquisition_aodi.id,
                          acquirer_id: lisi.id

        expect(response.status).to eq 403
      end
    end
  end
end
